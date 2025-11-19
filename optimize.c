#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"

/* Check if symbol is a constant */
int is_constant(SYM *s) {
    return (s != NULL && s->type == SYM_INT);
}

/* Get constant value */
int get_constant_value(SYM *s) {
    if (s == NULL || s->type != SYM_INT) {
        error("Not a constant");
        return 0;
    }
    return s->value;
}

/* Evaluate binary operation on constants */
int evaluate_binop(int op, int val1, int val2) {
    switch(op) {
        case TAC_ADD: return val1 + val2;
        case TAC_SUB: return val1 - val2;
        case TAC_MUL: return val1 * val2;
        case TAC_DIV: 
            if (val2 == 0) {
                error("Division by zero in constant folding");
                return 0;
            }
            return val1 / val2;
        case TAC_EQ: return val1 == val2;
        case TAC_NE: return val1 != val2;
        case TAC_LT: return val1 < val2;
        case TAC_LE: return val1 <= val2;
        case TAC_GT: return val1 > val2;
        case TAC_GE: return val1 >= val2;
        default:
            error("Unknown binary operator");
            return 0;
    }
}

/* Find or create a constant symbol */
SYM *find_or_create_const(int value) {
    return mk_const(value);
}

/* Check if TAC instruction uses a symbol */
int tac_uses_symbol(TAC *t, SYM *s) {
    if (t == NULL || s == NULL) return 0;
    
    switch(t->op) {
        case TAC_ADD:
        case TAC_SUB:
        case TAC_MUL:
        case TAC_DIV:
        case TAC_EQ:
        case TAC_NE:
        case TAC_LT:
        case TAC_LE:
        case TAC_GT:
        case TAC_GE:
            return (t->b == s || t->c == s);
            
        case TAC_NEG:
        case TAC_COPY:
        case TAC_OUTPUT:
        case TAC_RETURN:
        case TAC_ACTUAL:
            return (t->b == s);
            
        case TAC_IFZ:
            return (t->b == s);
            
        default:
            return 0;
    }
}

/* Replace symbol in TAC instruction */
void replace_symbol_in_tac(TAC *t, SYM *old_sym, SYM *new_sym) {
    if (t == NULL) return;
    
    if (t->a == old_sym) t->a = new_sym;
    if (t->b == old_sym) t->b = new_sym;
    if (t->c == old_sym) t->c = new_sym;
}

/* ============ Phase 1: Local Constant Folding ============ */

int local_constant_folding(BB *bb) {
    if (bb == NULL || bb->first == NULL) return 0;
    
    int changed = 0;
    TAC *t = bb->first;
    TAC *next_node;
    
    while (t != NULL) {
        next_node = t->next;
        int folded = 0;
        
        /* Binary operations */
        if (t->op >= TAC_ADD && t->op <= TAC_GE) {
            if (is_constant(t->b) && is_constant(t->c)) {
                int val1 = get_constant_value(t->b);
                int val2 = get_constant_value(t->c);
                int result = evaluate_binop(t->op, val1, val2);
                
                /* Replace with COPY */
                t->op = TAC_COPY;
                t->b = find_or_create_const(result);
                t->c = NULL;
                folded = 1;
                changed = 1;
            }
        }
        /* Unary NEG */
        else if (t->op == TAC_NEG) {
            if (is_constant(t->b)) {
                int val = get_constant_value(t->b);
                t->op = TAC_COPY;
                t->b = find_or_create_const(-val);
                folded = 1;
                changed = 1;
            }
        }
        /* 新增 IFZ 处理 */
        else if (t->op == TAC_IFZ && is_constant(t->b)) {
            int val = get_constant_value(t->b);
            if (val == 0) {
                // ifz 0 goto L  => goto L
                t->op = TAC_GOTO;
                t->b = NULL;
                changed = 1;
            } else {
                // ifz 1 goto L => 删除指令
                if (t->prev) t->prev->next = t->next;
                else bb->first = t->next; // 更新块头
                
                if (t->next) t->next->prev = t->prev;
                else bb->last = t->prev; // 更新块尾
                
                /* 删除后，不可再访问 t */
                changed = 1;
                t = next_node; /* 直接处理下一个 */
                continue;
            }
        }
        
        if (t == bb->last) break;
        t = next_node;
    }
    
    return changed;
}

/* ============ Phase 1: Local Algebraic Simplification ============ */

int local_algebraic_simplification(BB *bb) {
    if (bb == NULL || bb->first == NULL) return 0;
    
    int changed = 0;
    TAC *t = bb->first;
    
    while (t != NULL) {
        int simplified = 0;
        
        switch(t->op) {
            case TAC_ADD:
                /* x = a + 0 => x = a */
                if (is_constant(t->c) && get_constant_value(t->c) == 0) {
                    t->op = TAC_COPY;
                    t->c = NULL;
                    simplified = 1;
                }
                /* x = 0 + a => x = a */
                else if (is_constant(t->b) && get_constant_value(t->b) == 0) {
                    t->op = TAC_COPY;
                    t->b = t->c;
                    t->c = NULL;
                    simplified = 1;
                }
                break;
                
            case TAC_SUB:
                /* x = a - 0 => x = a */
                if (is_constant(t->c) && get_constant_value(t->c) == 0) {
                    t->op = TAC_COPY;
                    t->c = NULL;
                    simplified = 1;
                }
                /* x = a - a => x = 0 */
                else if (t->b == t->c && t->b != NULL) {
                    t->op = TAC_COPY;
                    t->b = find_or_create_const(0);
                    t->c = NULL;
                    simplified = 1;
                }
                break;
                
            case TAC_MUL:
                /* x = a * 0 => x = 0 */
                if (is_constant(t->c) && get_constant_value(t->c) == 0) {
                    t->op = TAC_COPY;
                    t->b = find_or_create_const(0);
                    t->c = NULL;
                    simplified = 1;
                }
                /* x = 0 * a => x = 0 */
                else if (is_constant(t->b) && get_constant_value(t->b) == 0) {
                    t->op = TAC_COPY;
                    t->b = find_or_create_const(0);
                    t->c = NULL;
                    simplified = 1;
                }
                /* x = a * 1 => x = a */
                else if (is_constant(t->c) && get_constant_value(t->c) == 1) {
                    t->op = TAC_COPY;
                    t->c = NULL;
                    simplified = 1;
                }
                /* x = 1 * a => x = a */
                else if (is_constant(t->b) && get_constant_value(t->b) == 1) {
                    t->op = TAC_COPY;
                    t->b = t->c;
                    t->c = NULL;
                    simplified = 1;
                }
                break;
                
            case TAC_DIV:
                /* x = a / 1 => x = a */
                if (is_constant(t->c) && get_constant_value(t->c) == 1) {
                    t->op = TAC_COPY;
                    t->c = NULL;
                    simplified = 1;
                }
                /* x = 0 / a => x = 0 (if a != 0) */
                else if (is_constant(t->b) && get_constant_value(t->b) == 0 &&
                         (!is_constant(t->c) || get_constant_value(t->c) != 0)) {
                    t->op = TAC_COPY;
                    t->b = find_or_create_const(0);
                    t->c = NULL;
                    simplified = 1;
                }
                break;
                
            case TAC_NEG:
                /* x = -(-a) would need more context, skip for now */
                break;
        }
        
        if (simplified) changed = 1;
        
        if (t == bb->last) break;
        t = t->next;
    }
    
    return changed;
}

/* ============ Phase 1: Local CSE ============ */

/* Expression hash table entry */
typedef struct expr_entry {
    int op;
    SYM *b;
    SYM *c;
    SYM *result;
    struct expr_entry *next;
} EXPR_ENTRY;

#define EXPR_HASH_SIZE 1145141

static EXPR_ENTRY *expr_table[EXPR_HASH_SIZE];

/* Hash function for expressions */
static unsigned int hash_expr(int op, SYM *b, SYM *c) {
    unsigned int hash = op;
    hash = hash * 31 + (unsigned long)b;
    hash = hash * 31 + (unsigned long)c;
    return hash % EXPR_HASH_SIZE;
}

/* Clear expression table */
static void clear_expr_table(void) {
    for (int i = 0; i < EXPR_HASH_SIZE; i++) {
        EXPR_ENTRY *e = expr_table[i];
        while (e != NULL) {
            EXPR_ENTRY *next = e->next;
            free(e);
            e = next;
        }
        expr_table[i] = NULL;
    }
}

/* Find expression in table */
static SYM *find_expr(int op, SYM *b, SYM *c) {
    unsigned int hash = hash_expr(op, b, c);
    // fprintf(stderr, "Search for %d %p %p in hash %d\n", op, b, c, hash);

    EXPR_ENTRY *e = expr_table[hash];
    
    while (e != NULL) {
        if (e->op == op && e->b == b && e->c == c) {
            return e->result;
        }
        e = e->next;
    }
    
    return NULL;
}

/* Add expression to table */
static void add_expr(int op, SYM *b, SYM *c, SYM *result) {
    unsigned int hash = hash_expr(op, b, c);
    EXPR_ENTRY *e = (EXPR_ENTRY *)malloc(sizeof(EXPR_ENTRY));
    
    e->op = op;
    e->b = b;
    e->c = c;
    e->result = result;
    e->next = expr_table[hash];
    expr_table[hash] = e;
}

/* Remove expressions that use a symbol */
static void kill_expr_using(SYM *s) {
    for (int i = 0; i < EXPR_HASH_SIZE; i++) {
        EXPR_ENTRY **pp = &expr_table[i];
        
        while (*pp != NULL) {
            EXPR_ENTRY *e = *pp;
            if (e->b == s || e->c == s || e->result == s) {
                *pp = e->next;
                free(e);
            } else {
                pp = &e->next;
            }
        }
    }
}

int local_cse(BB *bb) {
    if (bb == NULL || bb->first == NULL) return 0;
    
    clear_expr_table();
    int changed = 0;
    TAC *t = bb->first;
    
    while (t != NULL) {
        if (t->a != NULL && t->a->type == SYM_VAR) {
            kill_expr_using(t->a);
        }

        /* Check if this is a computable expression */
        if (t->op >= TAC_ADD && t->op <= TAC_NEG) {
            SYM *existing = NULL;
            
            /* For commutative operations, normalize operand order */
            if ((t->op == TAC_ADD || t->op == TAC_MUL || 
                 t->op == TAC_EQ || t->op == TAC_NE) && 
                t->c != NULL && (unsigned long)t->b > (unsigned long)t->c) {
                SYM *temp = t->b;
                t->b = t->c;
                t->c = temp;
            }
            
            /* Look for existing computation */
            existing = find_expr(t->op, t->b, t->c);
            

            if (existing != NULL) {
                /* Replace with copy */
                t->op = TAC_COPY;
                t->b = existing;
                t->c = NULL;
                changed = 1;
            } else {
                /* Add to expression table */
                if (t->a != NULL && t->a->type == SYM_VAR) {
                    add_expr(t->op, t->b, t->c, t->a);
                }
            }
        }
        
        /* Kill expressions on function calls (conservative) */
        if (t->op == TAC_CALL || t->op == TAC_INPUT) {
            clear_expr_table();
        }
        
        if (t == bb->last) break;
        t = t->next;
    }
    
    clear_expr_table();
    return changed;
}

/* ========================================================== */
/*               Global Data Flow Analysis Helpers            */
/* ========================================================== */

/* --- BitSet Implementation --- */

typedef struct bitset {
    unsigned int *bits;
    int size;     /* Number of bits */
    int n_words;  /* Number of integers used */
} BitSet;

static BitSet *bs_new(int size) {
    BitSet *bs = (BitSet *)malloc(sizeof(BitSet));
    bs->size = size;
    bs->n_words = (size + 31) / 32;
    bs->bits = (unsigned int *)calloc(bs->n_words, sizeof(unsigned int));
    return bs;
}

static void bs_free(BitSet *bs) {
    if(bs) { free(bs->bits); free(bs); }
}

static void bs_clear(BitSet *bs) {
    memset(bs->bits, 0, bs->n_words * sizeof(unsigned int));
}

static void bs_set(BitSet *bs, int i) {
    if (i >= 0 && i < bs->size)
        bs->bits[i / 32] |= (1 << (i % 32));
}

static int bs_test(BitSet *bs, int i) {
    if (i >= 0 && i < bs->size)
        return (bs->bits[i / 32] & (1 << (i % 32))) != 0;
    return 0;
}

/* Union: dst = src1 | src2. Returns 1 if dst changed. */
static int bs_union(BitSet *dst, BitSet *src1, BitSet *src2) {
    int changed = 0;
    for (int i = 0; i < dst->n_words; i++) {
        unsigned int old = dst->bits[i];
        unsigned int val = src1->bits[i] | src2->bits[i];
        dst->bits[i] = val;
        if (old != val) changed = 1;
    }
    return changed;
}

/* Copy: dst = src. Returns 1 if dst changed. */
static int bs_copy(BitSet *dst, BitSet *src) {
    int changed = 0;
    for (int i = 0; i < dst->n_words; i++) {
        if (dst->bits[i] != src->bits[i]) {
            dst->bits[i] = src->bits[i];
            changed = 1;
        }
    }
    return changed;
}

/* --- Variable Mapping (SYM* <-> ID) --- */

static SYM **var_map = NULL; /* Array of SYM pointers */
static int var_count = 0;

static void build_var_map() {
    /* Determine logical size for array. We iterate global list + local list later conceptually
       but here we scan pointers or assume we can find them.
       Simplest way: Scan ALL TAC in the function. */
}

static int get_var_id(SYM *s) {
    if (s == NULL || s->type != SYM_VAR) return -1;
    /* Linear scan is slow but safe for simple compiler. 
       Better: store ID in SYM->etc or offset temporarily */
    for (int i = 0; i < var_count; i++) {
        if (var_map[i] == s) return i;
    }
    return -1;
}

/* Initialize mapping for the current CFG */
static void init_global_analysis(CFG *cfg) {
    if (var_map) free(var_map);
    var_count = 0;
    
    /* Pass 1: Count variables */
    /* NOTE: We need a clean list of all variables. 
       Let's traverse the TAC list of the function. */
    
    /* Using a temporary max size */
    int capacity = 1024; 
    var_map = (SYM **)malloc(capacity * sizeof(SYM*));
    
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        for (TAC *t = bb->first; t != NULL; t = t->next) {
            SYM *syms[3] = {t->a, t->b, t->c};
            for (int i = 0; i < 3; i++) {
                SYM *s = syms[i];
                if (s && s->type == SYM_VAR) {
                    /* Check if exists */
                    int found = 0;
                    for (int j = 0; j < var_count; j++) {
                        if (var_map[j] == s) { found = 1; break; }
                    }
                    if (!found) {
                        if (var_count >= capacity) {
                            capacity *= 2;
                            var_map = (SYM**)realloc(var_map, capacity * sizeof(SYM*));
                        }
                        var_map[var_count++] = s;
                    }
                }
                /* Stop at end of BB */
                if (t == bb->last) break;
            }
        }
    }
}

/* ========================================================== */
/*         Phase 2: Global Const & Copy Propagation           */
/* ========================================================== */

/* Lattice Values */
#define LAT_TOP    0  /* Undefined / Not yet visited */
#define LAT_CONST  1  /* Constant value */
#define LAT_COPY   2  /* Copy of another variable */
#define LAT_BOTTOM 3  /* Not a constant / Varying */

typedef struct {
    int type;
    int val;     /* For LAT_CONST */
    SYM *copy;   /* For LAT_COPY */
} VarState;

/* Structure to hold state for all variables */
typedef struct var_state {
    VarState *vars; /* Array of size var_count */
} StateVector;

static StateVector *new_state_vector() {
    StateVector *sv = (StateVector *)malloc(sizeof(StateVector));
    sv->vars = (VarState *)malloc(var_count * sizeof(VarState));
    for(int i=0; i<var_count; i++) {
        sv->vars[i].type = LAT_TOP;
        sv->vars[i].copy = NULL;
        sv->vars[i].val = 0;
    }
    return sv;
}

/* Meet operator (Intersection) for Lattice */
static void meet_state(VarState *dst, VarState *src) {
    if (dst->type == LAT_BOTTOM) return;
    if (src->type == LAT_TOP) return; /* TOP n X = X (no change to dst) */
    
    if (dst->type == LAT_TOP) {
        *dst = *src;
        return;
    }
    
    if (src->type == LAT_BOTTOM) {
        dst->type = LAT_BOTTOM;
        return;
    }
    
    /* Both are CONST or COPY */
    if (dst->type == LAT_CONST) {
        if (src->type == LAT_CONST && dst->val == src->val) return;
        dst->type = LAT_BOTTOM;
    }
    else if (dst->type == LAT_COPY) {
        if (src->type == LAT_COPY && dst->copy == src->copy) return;
        dst->type = LAT_BOTTOM;
    }
    else {
        dst->type = LAT_BOTTOM;
    }
}

/* Helper: When 'modified' is changed, any var that was a copy of 'modified' is now invalid */
static void kill_copies_of(StateVector *sv, SYM *modified) {
    for (int i = 0; i < var_count; i++) {
        if (sv->vars[i].type == LAT_COPY && sv->vars[i].copy == modified) {
            sv->vars[i].type = LAT_BOTTOM;
            sv->vars[i].copy = NULL;
        }
    }
}

/* Transfer Function: Update state based on one instruction
   extracted to ensure consistency between Analysis and Rewrite phases */
static void transfer_block_instruction(StateVector *state, TAC *t) {
    /* 1. Kill Analysis: Function calls kill globals/memory */
    if (t->op == TAC_CALL) { 
        /* Conservative: Kill everything. In a real compiler, only global/escaped vars. */
        for(int i=0; i<var_count; i++) state->vars[i].type = LAT_BOTTOM;
        return; /* CALL also defines a return value (t->a), handled close below if present */
    }

    /* 2. General Definition Handling (Kill old value of t->a) */
    SYM *def = NULL;
    if (t->a && t->a->type == SYM_VAR) def = t->a;
    
    /* Special handling for TAC_COPY to perform Gen */
    if (def) {
        int id = get_var_id(def);
        if (id >= 0) {
            /* Important: Before overwriting 'def', invalidate anyone who was copying 'def' */
            kill_copies_of(state, def);

            if (t->op == TAC_COPY) {
                if (t->b->type == SYM_INT) {
                    state->vars[id].type = LAT_CONST;
                    state->vars[id].val = t->b->value;
                } 
                else if (t->b->type == SYM_VAR) {
                    int src_id = get_var_id(t->b);
                    /* Chain Resolution: If b is known const/copy, use that info */
                    if (src_id >= 0) {
                        if (state->vars[src_id].type == LAT_CONST) {
                            state->vars[id].type = LAT_CONST;
                            state->vars[id].val = state->vars[src_id].val;
                        } else if (state->vars[src_id].type == LAT_COPY && state->vars[src_id].copy) {
                            state->vars[id].type = LAT_COPY;
                            state->vars[id].copy = state->vars[src_id].copy; /* Point to the root */
                        } else {
                            /* b is just a variable (BOTTOM or TOP), treat as Copy of b */
                            state->vars[id].type = LAT_COPY;
                            state->vars[id].copy = t->b;
                        }
                    } else {
                         /* Should be treated as copy even if not in map yet (rare) */
                         state->vars[id].type = LAT_COPY;
                         state->vars[id].copy = t->b;
                    }
                } 
                else {
                    state->vars[id].type = LAT_BOTTOM;
                }
            } 
            else if (t->op >= TAC_ADD && t->op <= TAC_DIV) {
                /* Constant Folding Check */
                int v1 = 0, v2 = 0, k1 = 0, k2 = 0;
                
                if (t->b->type == SYM_INT) { k1=1; v1=t->b->value; }
                else {
                    int bid = get_var_id(t->b);
                    if (bid>=0 && state->vars[bid].type == LAT_CONST) { k1=1; v1=state->vars[bid].val; }
                }
                
                if (t->c->type == SYM_INT) { k2=1; v2=t->c->value; }
                else {
                    int cid = get_var_id(t->c);
                    if (cid>=0 && state->vars[cid].type == LAT_CONST) { k2=1; v2=state->vars[cid].val; }
                }

                if (k1 && k2) {
                    state->vars[id].type = LAT_CONST;
                    state->vars[id].val = evaluate_binop(t->op, v1, v2);
                } else {
                    state->vars[id].type = LAT_BOTTOM;
                }
            }
            else {
                /* For Input, Call result, etc., we don't know the value */
                state->vars[id].type = LAT_BOTTOM;
            }
        }
    }
}

static int global_propagation(CFG *cfg) {
    if (var_count == 0 || cfg == NULL || cfg->entry == NULL) return 0;

    /* 1. Initialize BB states */
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        if (bb->in_state) { free(bb->in_state->vars); free(bb->in_state); }
        if (bb->out_state) { free(bb->out_state->vars); free(bb->out_state); }
        
        bb->in_state = new_state_vector();
        bb->out_state = new_state_vector();
    }

    /* Initialize Entry Block: Assume inputs are BOTTOM */
    /* Technically local vars are TOP, but arguments are BOTTOM */
    for (int i = 0; i < var_count; i++) {
        cfg->entry->in_state->vars[i].type = LAT_BOTTOM;
    }

    int changed = 1;
    while (changed) {
        changed = 0;

        for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
            /* Compute IN[B] */
            if (bb != cfg->entry) {
                /* Reset to TOP */
                for(int i=0; i<var_count; i++) {
                    bb->in_state->vars[i].type = LAT_TOP;
                    bb->in_state->vars[i].copy = NULL;
                }
                
                if (bb->pred) {
                    for (ELIST *p = bb->pred; p != NULL; p = p->next) {
                        /* Skip unreachable/uninitialized predecessors */
                        if (!p->block->out_state) continue; 
                        
                        for (int i = 0; i < var_count; i++) {
                            meet_state(&bb->in_state->vars[i], &p->block->out_state->vars[i]);
                        }
                    }
                }
            }

            /* Compute OUT[B] */
            StateVector temp;
            temp.vars = (VarState *)malloc(var_count * sizeof(VarState));
            memcpy(temp.vars, bb->in_state->vars, var_count * sizeof(VarState));

            TAC *t = bb->first;
            while (t != NULL) {
                transfer_block_instruction(&temp, t);
                if (t == bb->last) break;
                t = t->next;
            }

            /* Check change */
            for (int i = 0; i < var_count; i++) {
                if (temp.vars[i].type != bb->out_state->vars[i].type ||
                    temp.vars[i].val != bb->out_state->vars[i].val || 
                    temp.vars[i].copy != bb->out_state->vars[i].copy) {
                    
                    bb->out_state->vars[i] = temp.vars[i];
                    changed = 1;
                }
            }
            free(temp.vars);
        }
    }

    /* 2. Application Phase (Rewrite TAC) */
    int applied = 0;
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        StateVector current;
        current.vars = (VarState *)malloc(var_count * sizeof(VarState));
        memcpy(current.vars, bb->in_state->vars, var_count * sizeof(VarState));

        TAC *t = bb->first;
        while (t != NULL) {
            /* Step A: Replace Operands using State BEFORE instruction execution */
            SYM **operands[2] = { &t->b, &t->c };
            for(int k=0; k<2; k++) {
                SYM **op = operands[k];
                if (*op && (*op)->type == SYM_VAR) {
                    int id = get_var_id(*op);
                    if (id >= 0) {
                        if (current.vars[id].type == LAT_CONST) {
                            *op = mk_const(current.vars[id].val);
                            applied = 1;
                        } else if (current.vars[id].type == LAT_COPY && current.vars[id].copy) {
                            *op = current.vars[id].copy;
                            applied = 1;
                        }
                    }
                }
            }

            /* Step B: Update State (Transfer Function) using the instruction itself */
            /* Note: we pass 'current' which is modified in-place */
            transfer_block_instruction(&current, t);

            if (t == bb->last) break;
            t = t->next;
        }
        free(current.vars);
    }

    return applied;
}



/* ========================================================== */
/*           Phase 3: Global Liveness & DCE                   */
/* ========================================================== */

static void compute_local_liveness(BB *bb) {
    bs_clear(bb->live_gen);
    bs_clear(bb->live_kill);

    if (bb->first == NULL) return;

    /* 必须正向扫描来构建 GEN/KILL 集合 */
    TAC *t = bb->first;
    while (t != NULL) {
        /* 1. 处理 USE (读取变量) 
           如果变量在被定义(KILL)之前就被读取，加入 GEN */
        SYM *uses[3] = {NULL, NULL, NULL};
        int n_uses = 0;

        switch (t->op) {
            case TAC_ADD: case TAC_SUB: case TAC_MUL: case TAC_DIV:
            case TAC_EQ: case TAC_NE: case TAC_LT: case TAC_LE: 
            case TAC_GT: case TAC_GE:
                uses[0] = t->b; uses[1] = t->c; n_uses = 2;
                break;
            case TAC_NEG: case TAC_COPY:
                uses[0] = t->b; n_uses = 1;
                break;
            case TAC_IFZ:
                uses[0] = t->b; n_uses = 1; /* ifz b goto a */
                break;
            case TAC_RETURN: case TAC_OUTPUT: case TAC_ACTUAL:
                uses[0] = t->a; n_uses = 1; /* return a, output a */
                break;
            /* TAC_CALL 的参数通常通过之前的 TAC_ACTUAL 传递，
               但如果你的实现支持 call b (b是函数指针变量)，这里也要处理 */
        }

        for (int i = 0; i < n_uses; i++) {
            if (uses[i] && uses[i]->type == SYM_VAR) {
                int id = get_var_id(uses[i]);
                if (id >= 0) {
                    /* 只有之前没有被当前块 Kill 掉的变量，才算是从外部输入的活跃变量 */
                    if (!bs_test(bb->live_kill, id)) {
                        bs_set(bb->live_gen, id);
                    }
                }
            }
        }

        /* 2. 处理 DEF (定义/写入变量) */
        SYM *def = NULL;
        switch (t->op) {
            case TAC_ADD: case TAC_SUB: case TAC_MUL: case TAC_DIV:
            case TAC_EQ: case TAC_NE: case TAC_LT: case TAC_LE: 
            case TAC_GT: case TAC_GE: case TAC_NEG: case TAC_COPY:
            case TAC_CALL: case TAC_INPUT: case TAC_VAR:
                def = t->a; /* a = ... */
                break;
        }

        if (def && def->type == SYM_VAR) {
            int id = get_var_id(def);
            if (id >= 0) {
                bs_set(bb->live_kill, id);
            }
        }
        
        if (t == bb->last) break;
        t = t->next;
    }
}


/* Solve Data Flow Equations:
   IN[B] = GEN[B] U (OUT[B] - KILL[B])
   OUT[B] = U (IN[S]) for S in successors
*/
static void solve_liveness(CFG *cfg) {
    /* Init sets */
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        if(bb->live_gen) bs_free(bb->live_gen); bb->live_gen = bs_new(var_count);
        if(bb->live_kill) bs_free(bb->live_kill); bb->live_kill = bs_new(var_count);
        if(bb->live_in) bs_free(bb->live_in); bb->live_in = bs_new(var_count);
        if(bb->live_out) bs_free(bb->live_out); bb->live_out = bs_new(var_count);
        
        compute_local_liveness(bb);
    }

    int changed = 1;
    while (changed) {
        changed = 0;
        /* Backward Traversal (helps convergence) - approximated by simple list order here */
        for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
            
            /* Compute OUT */
            bs_clear(bb->live_out);
            if (bb->succ) {
                for (ELIST *s = bb->succ; s != NULL; s = s->next) {
                    bs_union(bb->live_out, bb->live_out, s->block->live_in);
                }
            }

            /* Compute IN = GEN U (OUT - KILL) */
            /* Temp = OUT - KILL */
            BitSet *temp = bs_new(var_count);
            for (int i=0; i<var_count; i++) {
                if (bs_test(bb->live_out, i) && !bs_test(bb->live_kill, i))
                    bs_set(temp, i);
            }
            /* IN = GEN U Temp */
            bs_union(temp, temp, bb->live_gen);
            
            if (bs_copy(bb->live_in, temp)) {
                changed = 1;
            }
            bs_free(temp);
        }
    }
}

static int global_dce(CFG *cfg) {
    if (var_count == 0) return 0;
    
    /* 第一步：计算块级别的活跃性 (IN/OUT) */
    solve_liveness(cfg);
    
    int changed = 0;
    
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        /* 初始化当前活跃集为块出口的活跃集 (OUT) */
        BitSet *live = bs_new(var_count);
        bs_copy(live, bb->live_out);
        
        /* 倒序扫描指令 */
        TAC *t = bb->last;
        while (t != NULL) {
            TAC *prev = t->prev; /* 保存前驱，因为 t 可能被 free */
            int is_dead = 0;
            
            /* 1. 检查 DEFINITION (写操作) 是否死代码 */
            SYM *def = NULL;
            switch (t->op) {
                case TAC_ADD: case TAC_SUB: case TAC_MUL: case TAC_DIV:
                case TAC_EQ: case TAC_NE: case TAC_LT: case TAC_LE: 
                case TAC_GT: case TAC_GE: case TAC_NEG: case TAC_COPY:
                     def = t->a;
                     break;
                case TAC_CALL: case TAC_INPUT: case TAC_VAR:
                     /* CALL 和 INPUT 有副作用（IO/状态改变），永远不能视为死代码，
                        即使返回值没被用，指令本身必须保留。
                        但在本简单的活跃性分析中，我们暂不删除它们。 */
                     def = NULL; 
                     break;
            }

            if (def && def->type == SYM_VAR) {
                int id = get_var_id(def);
                if (id >= 0) {
                    if (!bs_test(live, id)) {
                        /* 变量在后面没有被使用，且该指令无副作用 -> 删除 */
                        is_dead = 1;
                    } else {
                        /* 变量是活的，但这行代码覆盖了它。
                           所以在代码的“上方”，这个变量不再活跃（除非被自身引用 a=a+1）。
                           我们需要从 live 集中移除它。 */
                        live->bits[id/32] &= ~(1 << (id%32)); 
                    }
                }
            }
            
            if (is_dead) {
                /* 执行删除 */
                if (t->prev) t->prev->next = t->next;
                else bb->first = t->next;
                
                if (t->next) t->next->prev = t->prev;
                else bb->last = t->prev;
                
                // free(t); // 建议暂不 free，防止指针悬挂，或者小心处理
                changed = 1;
            } else {
                /* 2. 标记 USE (读操作) 为活跃 */
                /* 如果指令保留下来了，它用到的变量在“上方”就变成了活跃的 */
                SYM *uses[3] = {NULL, NULL, NULL};
                int n_uses = 0;

                switch (t->op) {
                    case TAC_ADD: case TAC_SUB: case TAC_MUL: case TAC_DIV:
                    case TAC_EQ: case TAC_NE: case TAC_LT: case TAC_LE: 
                    case TAC_GT: case TAC_GE:
                        uses[0] = t->b; uses[1] = t->c; n_uses = 2;
                        break;
                    case TAC_NEG: case TAC_COPY:
                        uses[0] = t->b; n_uses = 1;
                        break;
                    case TAC_IFZ:
                        uses[0] = t->b; n_uses = 1;
                        break;
                    case TAC_RETURN: case TAC_OUTPUT: case TAC_ACTUAL:
                        uses[0] = t->a; n_uses = 1; /* 关键修复点！ */
                        break;
                }

                for (int i = 0; i < n_uses; i++) {
                    if (uses[i] && uses[i]->type == SYM_VAR) {
                        int id = get_var_id(uses[i]);
                        if (id >= 0) bs_set(live, id);
                    }
                }
            }
            
            if (t == bb->first) break;
            t = prev;
        }
        bs_free(live);
    }
    return changed;
}

/* ========================================================== */
/*          Phase 0: Unreachable Code Elimination             */
/* ========================================================== */

/* 深度优先搜索标记可达块 */
static void mark_reachable(BB *bb, BitSet *visited) {
    if (bb == NULL || bs_test(visited, bb->id)) return;
    
    bs_set(visited, bb->id);
    
    /* 遍历后继节点 */
    if (bb->succ) {
        for (ELIST *e = bb->succ; e != NULL; e = e->next) {
            mark_reachable(e->block, visited);
        }
    }
}

/* 删除 TAC 链表中的一段 */
static void remove_tac_range(TAC *start, TAC *end) {
    if (!start || !end) return;
    
    /* 处理链表头尾指针 (tac_first, tac_last 是全局变量) */
    if (start->prev) start->prev->next = end->next;
    else tac_first = end->next; /* 如果删除了头部 */
    
    if (end->next) end->next->prev = start->prev;
    else tac_last = start->prev; /* 如果删除了尾部 */
}

static int eliminate_unreachable_code(CFG *cfg) {
    if (cfg->entry == NULL) return 0;
    
    /* 1. 标记可达块 */
    BitSet *visited = bs_new(cfg->nblocks + 1); /* +1 防止 id 越界 */
    mark_reachable(cfg->entry, visited);
    
    int changed = 0;
    
    /* 2. 遍历所有块，删除未标记的块 */
    BB *curr = cfg->list;
    BB *prev = NULL;
    
    while (curr != NULL) {
        if (!bs_test(visited, curr->id)) {
            /* 这是一个不可达块 */
            // fprintf(stderr, "Removing unreachable block %d\n", curr->id);
            
            /* 从代码中删除指令 */
            if (curr->first != NULL) {
                remove_tac_range(curr->first, curr->last);
            }
            
            /* 从 CFG 链表中移除改块 */
            if (prev) prev->next = curr->next;
            else cfg->list = curr->next;
            
            /* 注意：标准的实现还需要清理 succ/pred 边关系，
               但在简单的 TAC 线性扫描编译器中，删除指令和 CFG 节点通常就足够了。*/
               
            changed = 1;
            BB *next_block = curr->next;
            /* free(curr); // 如果有内存管理需求 */
            curr = next_block;
        } else {
            prev = curr;
            curr = curr->next;
        }
    }
    
    bs_free(visited);
    return changed;
}

/* ========================================================== */
/*          Phase 4: Global Common Subexpression Elimination   */
/* ========================================================== */

/* --- 表达式全集管理 (Expression Universe) --- */

typedef struct expr_def {
    int id;
    int op;
    SYM *b;
    SYM *c;
    struct expr_def *next;
} ExprDef;

static ExprDef *expr_universe = NULL;
static int expr_count = 0;

static void clear_expr_universe() {
    ExprDef *e = expr_universe;
    while (e) {
        ExprDef *next = e->next;
        free(e);
        e = next;
    }
    expr_universe = NULL;
    expr_count = 0;
}

/* 获取或创建表达式 ID */
static int get_expr_id(int op, SYM *b, SYM *c) {
    /* 规范化：对于可交换操作符，确保 b < c */
    if (op == TAC_ADD || op == TAC_MUL || op == TAC_EQ || op == TAC_NE) {
        if ((unsigned long)b > (unsigned long)c) {
            SYM *tmp = b; b = c; c = tmp;
        }
    }

    /* 查找是否存在 */
    for (ExprDef *e = expr_universe; e != NULL; e = e->next) {
        if (e->op == op && e->b == b && e->c == c) return e->id;
    }

    /* 创建新表达式 */
    ExprDef *new_expr = (ExprDef *)malloc(sizeof(ExprDef));
    new_expr->id = expr_count++;
    new_expr->op = op;
    new_expr->b = b;
    new_expr->c = c;
    new_expr->next = expr_universe;
    expr_universe = new_expr;
    
    return new_expr->id;
}

/* --- 计算 AE GEN 和 AE KILL 集合 --- */

static void compute_ae_gen_kill(BB *bb) {
    bs_clear(bb->ae_gen);
    bs_clear(bb->ae_kill);

    TAC *t = bb->first;
    while (t != NULL) {
        /* 检查指令是否生成了可用表达式 */
        if (t->op >= TAC_ADD && t->op <= TAC_GE && t->a && t->a->type == SYM_VAR) {
            int id = get_expr_id(t->op, t->b, t->c);
            
            /* t->a = t->b op t->c */
            /* GEN 逻辑: 该表达式在块内被计算 */
            bs_set(bb->ae_gen, id);
            /* 并在 KILL 集中移除（因为重新生成了） */
            if (bb->ae_kill->bits[id/32] & (1<<(id%32))) {
                 bb->ae_kill->bits[id/32] &= ~(1<<(id%32));
            }
        }

        /* KILL 逻辑: 
           任何对变量 v 的赋值，都会杀死所有包含 v 的表达式 */
        SYM *def = NULL;
        if (t->a && t->a->type == SYM_VAR) def = t->a;
        
        if (def) {
            for (ExprDef *e = expr_universe; e != NULL; e = e->next) {
                if (e->b == def || e->c == def) {
                    bs_set(bb->ae_kill, e->id);
                    /* 同时从 GEN 中移除，因为操作数被改了 */
                    if (bb->ae_gen->bits[e->id/32] & (1<<(e->id%32))) {
                        bb->ae_gen->bits[e->id/32] &= ~(1<<(e->id%32));
                    }
                }
            }
        }

        if (t == bb->last) break;
        t = t->next;
    }
}

/* --- 解决可用表达式数据流方程 --- */
/* IN[B] = ∩ (OUT[P])  (所有前驱的交集)
   OUT[B] = GEN[B] U (IN[B] - KILL[B])
   初始条件：OUT[Entry] = Empty, OUT[Other] = Universal Set (全1)
*/
static void solve_available_expressions(CFG *cfg) {
    if (expr_count == 0) return;

    /* 1. 初始化集合 */
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        if(bb->ae_gen) bs_free(bb->ae_gen); bb->ae_gen = bs_new(expr_count);
        if(bb->ae_kill) bs_free(bb->ae_kill); bb->ae_kill = bs_new(expr_count);
        if(bb->ae_in) bs_free(bb->ae_in); bb->ae_in = bs_new(expr_count);
        if(bb->ae_out) bs_free(bb->ae_out); bb->ae_out = bs_new(expr_count);

        /* 计算本地 GEN/KILL */
        compute_ae_gen_kill(bb);
        
        /* 初始化 OUT 集合 */
        if (bb == cfg->entry) {
            bs_clear(bb->ae_out); /* Entry 没有任何可用表达式 */
        } else {
            /* 其他块初始化为全集 (1111...)，以便进行交集运算 */
            memset(bb->ae_out->bits, 0xFF, bb->ae_out->n_words * sizeof(unsigned int));
            /* 修正最后一个字的溢出位（虽然不修正通常也没事，但严谨点） */
        }
    }

    /* 2. 迭代求解 */
    int changed = 1;
    while (changed) {
        changed = 0;
        for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
            if (bb == cfg->entry) continue;

            /* 计算 IN = Intersect(OUT[Pred]) */
            /* 先设 IN 为全集 */
            memset(bb->ae_in->bits, 0xFF, bb->ae_in->n_words * sizeof(unsigned int));
            
            if (bb->pred == NULL) {
                /* 如果没有前驱且不是 Entry，说明是不可达块，清空 IN */
                bs_clear(bb->ae_in);
            } else {
                for (ELIST *p = bb->pred; p != NULL; p = p->next) {
                    /* Bitwise AND */
                    for (int i = 0; i < bb->ae_in->n_words; i++) {
                        bb->ae_in->bits[i] &= p->block->ae_out->bits[i];
                    }
                }
            }

            /* 计算 OUT = GEN U (IN - KILL) */
            BitSet *old_out = bs_new(expr_count);
            bs_copy(old_out, bb->ae_out);

            /* Temp = IN - KILL */
            BitSet *temp = bs_new(expr_count);
            for(int i=0; i<expr_count; i++) {
                if (bs_test(bb->ae_in, i) && !bs_test(bb->ae_kill, i)) {
                    bs_set(temp, i);
                }
            }
            /* OUT = GEN U Temp */
            bs_union(bb->ae_out, bb->ae_gen, temp);

            /* 检查是否收敛 */
            for(int i=0; i<bb->ae_out->n_words; i++) {
                if (bb->ae_out->bits[i] != old_out->bits[i]) {
                    changed = 1;
                    break;
                }
            }

            bs_free(old_out);
            bs_free(temp);
        }
    }
}

/* ========================================================== */
/*          Phase 4: Global Common Subexpression Elimination   */
/* ========================================================== */

/* ... 前面的 ExprDef, get_expr_id, compute_ae_gen_kill, solve_available_expressions 保持不变 ... */
/* 请确保 solve_available_expressions 上方的辅助函数都在 */

/* 具体的替换实施函数 */
static int global_cse(CFG *cfg) {
    /* 1. 构建表达式全集 */
    clear_expr_universe();
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        TAC *t = bb->first;
        while (t != NULL) {
            if (t->op >= TAC_ADD && t->op <= TAC_GE && t->a && t->a->type == SYM_VAR) {
                get_expr_id(t->op, t->b, t->c);
            }
            if (t == bb->last) break;
            t = t->next;
        }
    }
    
    if (expr_count == 0) return 0;

    /* 2. 运行数据流分析 (得到 ae_in 和 ae_out) */
    solve_available_expressions(cfg);
    
    /* 3. 替换阶段 (Rewrite Phase) */
    int changed = 0;
    
    /* 
       我们需要保存每个块出口处的变量映射状态，以便后继块使用。
       block_maps[bb_id][expr_id] = 存放该表达式值的变量 (SYM*) 或 NULL
    */
    int max_bb_id = 0;
    for(BB *bb = cfg->list; bb != NULL; bb = bb->next) if(bb->id > max_bb_id) max_bb_id = bb->id;
    
    SYM ***block_maps = (SYM ***)calloc(max_bb_id + 1, sizeof(SYM**));
    for(int i = 0; i <= max_bb_id; i++) {
        block_maps[i] = (SYM **)calloc(expr_count, sizeof(SYM*));
    }

    /* 按照 CFG 链表顺序遍历进行替换 
       注意：对于回边（循环），我们在第一次访问时可能只有部分前驱信息，
       但这在 CSE 中是安全的（只会漏掉优化，不会出错），
       且 solve_available_expressions 已经处理了循环的数据流收敛。
    */
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        SYM **current_map = (SYM **)malloc(expr_count * sizeof(SYM*));
        
        /* A. 初始化当前块的 Map (In-Map) */
        if (bb == cfg->entry) {
            for(int i=0; i<expr_count; i++) current_map[i] = NULL;
        } else {
            /* 设为全 NULL 或第一个前驱的状态，然后求交集 */
            int first = 1;
            
            /* 从 ae_in 初始化：如果 bitset 说不可用，则 map 必定为 NULL
               如果 bitset 说可用，我们需要看前驱的一致性 */
            
            if (bb->pred == NULL) {
                /* 不可达块 */
                for(int i=0; i<expr_count; i++) current_map[i] = NULL;
            } else {
                for (ELIST *p = bb->pred; p != NULL; p = p->next) {
                    BB *pred = p->block;
                    /* 只有当前驱已经被处理过（即不是回边及其未访问的节点），map才有意义。
                       但在全局分析后，我们可以利用 iterative data flow 的性质。
                       简单起见，如果前驱的 map 还没生成（回边情况），为了安全，视为不匹配。
                       改进：这里其实只处理前向边优化。循环不变量外提是另一个优化。
                    */
                    
                    /* 这里简化处理：只在这个 loop 中向前传递 map。
                       这能捕获大部分 DAG 结构的 CSE。 */
                    
                    if (first) {
                        /* 复制第一个前驱的 map */
                        for(int i=0; i<expr_count; i++) {
                            current_map[i] = block_maps[pred->id][i];
                        }
                        first = 0;
                    } else {
                        /* 求交集：如果不一致，则置为 NULL */
                        for(int i=0; i<expr_count; i++) {
                            if (current_map[i] != block_maps[pred->id][i]) {
                                current_map[i] = NULL;
                            }
                        }
                    }
                }
            }
        }

        /* 双重检查：必须与 ae_in 保持一致 */
        /* 如果数据流分析说该表达不可用，即使 Map 碰巧有值也必须清除（防止误判） */
        for(int i=0; i<expr_count; i++) {
            if (!bs_test(bb->ae_in, i)) {
                current_map[i] = NULL;
            }
        }

        /* B. 遍历指令进行替换和更新 */
        TAC *t = bb->first;
        while (t != NULL) {
            /* 1. 尝试替换 (CSE) */
            if (t->op >= TAC_ADD && t->op <= TAC_GE && t->a && t->a->type == SYM_VAR) {
                int id = get_expr_id(t->op, t->b, t->c);
                
                if (current_map[id] != NULL) {
                    /* 发现公共子表达式！执行替换 */
                    /* t->a = t->b op t->c  ==>  t->a = available_var */
                    
                    /* 检查: 替换源变量必须是局部/全局变量或常量，且类型匹配 */
                    /* 这里只要不为空，逻辑上就是安全的 */
                    
                    t->op = TAC_COPY;
                    t->b = current_map[id];
                    t->c = NULL;
                    changed = 1;
                    
                    /* 注意：现在 t->a 也持有了该表达式的值，
                       所以 mapping[id] 依然有效，甚至可以指向 t->a（取决于策略）。
                       保持原样通常更好（指向最早生成的那个变量）。 */
                } else {
                    /* 表达式不可用，这是首次计算（或重新计算） */
                    /* GEN: 记录该表达式现在存在 t->a 中 */
                    current_map[id] = t->a;
                }
            }

            /* 2. 处理 KILL (变量重定义) */
            /* 任何对变量 v 的赋值，都会导致：
               1. 任何结果存在 v 中的表达式失效 (Map[id] == v -> NULL)
               2. 任何使用 v 作为操作数的表达式失效 (Map[id] 依赖 v -> NULL)
            */
            
            SYM *def = NULL;
            if (t->a && t->a->type == SYM_VAR) def = t->a; // 通用赋值目标
            /* 注意：TAC_COPY, TAC_ADD... 以及 TAC_INPUT, TAC_CALL 都会写变量 */
            switch(t->op) {
                case TAC_CALL: case TAC_INPUT: case TAC_VAR: 
                    if (t->a && t->a->type == SYM_VAR) def = t->a;
                    break;
            }

            if (def) {
                for (ExprDef *e = expr_universe; e != NULL; e = e->next) {
                    /* Case 1: 表达式的值原本存在 def 中，现在 def 变了 */
                    if (current_map[e->id] == def) {
                        /* 特例：如果是刚才那条指令 (a = b+c) 刚把 a 放进去，不要这行删掉。
                           如果是 t->op == TAC_COPY (上面的 CSE替换结果)，
                           或者是 t->op == ADD (生成指令)，
                           那么在指令 '后'，a 确实持有该值。
                           
                           但是，如果是 a = input() 或 a = 10 (常量)，那么旧的 expr 值确实丢了。
                        */
                        
                        /* 简单判定：只有当这条指令 生成了 e->id 且目标是 def 时，才保留。
                           否则（例如 a = 5, 或 a = d + e 覆盖了 old_expr），Kill。 */
                        
                        int approach_kill = 1;
                        if (t->op >= TAC_ADD && t->op <= TAC_GE) {
                             int gen_id = get_expr_id(t->op, t->b, t->c);
                             if (gen_id == e->id) approach_kill = 0;
                        }
                        /* 如果是 CSE 替换成的 COPY (a = old_a)，值其实没变，
                           但为了保险或应对 Copy Prop，杀掉也没大错，
                           除非我们做很精细的别名分析。这里选择保守策略: Kill。
                           但在 CSE 成功分支里，我们刚 update 了 map[id]=available，
                           然后马上遇到 Kill 逻辑。
                           
                           逻辑修正：如果是 CSE 刚发生的指令，不要 Kill 刚才那个 ID。
                        */
                        if (approach_kill) current_map[e->id] = NULL;
                    }

                    /* Case 2: 表达式的操作数被修改了 */
                    if (e->b == def || e->c == def) {
                        current_map[e->id] = NULL;
                    }
                }
            }

            /* Call 和 Input 副作用处理 (可选，视语言语义而定) */
            /* 如果有全局变量或指针别名，CALL 可能会改写内存。
               在这个简单的 TAC 中，假设只改写 ret 变量 (已在上面 def 处理)。 */

            if (t == bb->last) break;
            t = t->next;
        }

        /* C. 保存 Out-Map 供后继块使用 */
        for(int i=0; i<expr_count; i++) {
            block_maps[bb->id][i] = current_map[i];
        }
        free(current_map);
    }

    /* 清理内存 */
    for(int i = 0; i <= max_bb_id; i++) free(block_maps[i]);
    free(block_maps);
    
    return changed;
}



/* ========================================================== */
/*               Main Optimization Driver                     */
/* ========================================================== */

/* optimize.c */

void optimize_all_functions(void) {
    TAC *t = tac_first;
    
    fprintf(file_x, "\n/* ========== Global Optimizations ========== */\n");
    
    while (t != NULL) {
        if (t->op == TAC_BEGINFUNC) {
            TAC *begin = t;
            TAC *end = t->next;
            while (end != NULL && end->op != TAC_ENDFUNC) end = end->next;
            if (end == NULL) break;
            
            /* 第一次构建 CFG */
            CFG *cfg = build_cfg_for_func(begin, end);
            
            if (cfg != NULL) {
                fprintf(file_x, "\n/* Optimizing function %s */\n", cfg->func_name);
                
                /* 初始变量映射构建 */
                init_global_analysis(cfg);

                int iteration = 0;
                int changed;
                
                do {
                    changed = 0;
                    iteration++;
                    
                    /* =================================================== */
                    /* Step 1: 局部优化 (Local Optimizations)            */
                    /* 这些优化可能会改变指令，包括删除跳转指令             */
                    /* =================================================== */
                    int local_changed = 0;
                    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
                        local_changed |= local_constant_folding(bb);       /* 包含 IFZ 消除 */
                        local_changed |= local_algebraic_simplification(bb);
                        local_changed |= local_cse(bb);
                    }
                    
                    /* =================================================== */
                    /* Step 2: 检查是否需要重建 CFG                       */
                    /* 如果局部优化改变了代码(特别是控制流)，旧图已失效      */
                    /* =================================================== */
                    if (local_changed) {
                        /* 1. 释放旧的 CFG 和分析数据 */
                        /* 注意: free_cfg 不会释放 TAC 指令本身，只会释放 BB 结构和边 */
                        free_cfg(cfg);
                        
                        /* 2. 基于修改后的 TAC 链表重新构建 CFG */
                        cfg = build_cfg_for_func(begin, end);
                        
                        /* 3. 重新初始化全局分析所需的映射 (如 var_map) */
                        init_global_analysis(cfg);
                        
                        changed = 1; /* 标记发生了改变，需要继续迭代 */
                    }

                    /* =================================================== */
                    /* Step 3: 不可达代码消除 (Unreachable Code Elimination) */
                    /* 此时 CFG 是最新的，可以正确识别断开连接的块          */
                    /* =================================================== */
                    changed |= eliminate_unreachable_code(cfg);
                    
                    /* 如果消除了块，理论上我们又改变了 CFG 结构。
                       稍微严谨且简单的做法是：如果在这一步删除了块，
                       在下一轮循环开头 local_opt 之前，结构也是合法的（链表是好的），
                       或者我们可以选择再次重建。
                       但在当前实现下，eliminate_unreachable_code 维护了链表完整性，
                       我们可以继续做数据流分析。
                    */

                    /* =================================================== */
                    /* Step 4: 全局数据流分析与优化 (Data Flow Analysis)    */
                    /* 依赖于准确的 CFG                                   */
                    /* =================================================== */
                    
                    /* 全局常量/拷贝传播 */
                    changed |= global_propagation(cfg);
                    
                    /* 全局公共子表达式消除 (Analysis + Rewrite) */
                    changed |= global_cse(cfg);
                    
                    /* 全局死代码消除 (Liveness Analysis + Remove) */
                    changed |= global_dce(cfg);
                    
                } while (changed && iteration < 30);
                
                fprintf(file_x, "/* Result: %d iterations */\n", iteration);
                
                /* 最终清理 */
                free_cfg(cfg); 
                /* free(var_map); // 如果 var_map 是全局分配的 */
            }
            t = end->next;
        } else {
            t = t->next;
        }
    }
}
