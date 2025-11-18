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
    
    while (t != NULL) {
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
        
        if (t == bb->last) break;
        t = t->next;
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

/* ============ Main Optimization Driver ============ */

void optimize_all_functions(void) {
    TAC *t = tac_first;
    
    fprintf(file_x, "\n/* ========== Local Optimizations ========== */\n");
    
    while (t != NULL) {
        if (t->op == TAC_BEGINFUNC) {
            TAC *begin = t;
            TAC *end = t->next;
            
            /* Find matching ENDFUNC */
            while (end != NULL && end->op != TAC_ENDFUNC) {
                end = end->next;
            }
            
            if (end == NULL) {
                error("BEGINFUNC without matching ENDFUNC");
                break;
            }
            
            /* Build CFG */
            CFG *cfg = build_cfg_for_func(begin, end);
            
            if (cfg != NULL) {
                fprintf(file_x, "\n/* Optimizing function %s */\n", cfg->func_name);
                
                int total_changed = 0;
                int iteration = 0;
                int changed;
                
                /* Iterate until no more changes */
                do {
                    changed = 0;
                    iteration++;
                    
                    /* Apply optimizations to each basic block */
                    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
                        int bb_changed = 0;
                        
                        bb_changed |= local_constant_folding(bb);
                        bb_changed |= local_algebraic_simplification(bb);
                        bb_changed |= local_cse(bb);
                        
                        changed |= bb_changed;
                    }
                    
                    total_changed |= changed;
                    
                } while (changed && iteration < 10);
                
                fprintf(file_x, "/* %s: %d iterations, %s */\n", 
                        cfg->func_name, iteration,
                        total_changed ? "optimized" : "no changes");
                
                free_cfg(cfg);
            }
            
            t = end->next;
        } else {
            t = t->next;
        }
    }
}