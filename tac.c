#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include "tac.h"

/* global var */
int scope, next_tmp, next_label;
SYM *sym_tab_global, *sym_tab_local;
TAC *tac_first, *tac_last;

void tac_init()
{
	scope=0;
	sym_tab_global=NULL;
	sym_tab_local=NULL;	
	next_tmp=0;
	next_label=1;
}

void tac_complete()
{
	TAC *cur=NULL; 		/* Current TAC */
	TAC *prev=tac_last; 	/* Previous TAC */

	while(prev !=NULL)
	{
		prev->next=cur;
		cur=prev;
		prev=prev->prev;
	}

	tac_first = cur;
}

SYM *lookup_sym(SYM *symtab, char *name)
{
	SYM *t=symtab;

	while(t !=NULL)
	{
		if(strcmp(t->name, name)==0) break; 
		else t=t->next;
	}
	
	return t; /* NULL if not found */
}

void insert_sym(SYM **symtab, SYM *sym)
{
	sym->next=*symtab; /* Insert at head */
	*symtab=sym;
}

SYM *mk_sym(void)
{
	SYM *t;
	t=(SYM *)malloc(sizeof(SYM));
	return t;
}

SYM *mk_var(char *name)
{
	SYM *sym=NULL;

	if(scope)  
		sym=lookup_sym(sym_tab_local,name);
	else
		sym=lookup_sym(sym_tab_global,name);

	/* var already declared */
	if(sym!=NULL)
	{
		error("variable already declared");
		return NULL;
	}

	/* var unseen before, set up a new symbol table node, insert_sym it into the symbol table. */
	sym=mk_sym();
	sym->type=SYM_VAR;
	sym->name=name;
	sym->offset=-1; /* Unset address */

	if(scope)  
		insert_sym(&sym_tab_local,sym);
	else
		insert_sym(&sym_tab_global,sym);

	return sym;
}

TAC *join_tac(TAC *c1, TAC *c2)
{
	TAC *t;

	if(c1==NULL) return c2;
	if(c2==NULL) return c1;

	/* Run down c2, until we get to the beginning and then add c1 */
	t=c2;
	while(t->prev !=NULL) 
		t=t->prev;

	t->prev=c1;
	return c2;
}

TAC *declare_var(char *name)
{
	return mk_tac(TAC_VAR,mk_var(name),NULL,NULL);
}

TAC *mk_tac(int op, SYM *a, SYM *b, SYM *c)
{
	TAC *t=(TAC *)malloc(sizeof(TAC));

	t->next=NULL; /* Set these for safety */
	t->prev=NULL;
	t->op=op;
	t->a=a;
	t->b=b;
	t->c=c;

	return t;
}  

SYM *mk_label(char *name)
{
	SYM *t=mk_sym();

	t->type=SYM_LABEL;
	t->name=strdup(name);

	return t;
}  

TAC *do_func(SYM *func, TAC *args, TAC *code)
{
	TAC *tlist; /* The backpatch list */

	TAC *tlab; /* Label at start of function */
	TAC *tbegin; /* BEGINFUNC marker */
	TAC *tend; /* ENDFUNC marker */

	tlab=mk_tac(TAC_LABEL, mk_label(func->name), NULL, NULL);
	tbegin=mk_tac(TAC_BEGINFUNC, NULL, NULL, NULL);
	tend=mk_tac(TAC_ENDFUNC,   NULL, NULL, NULL);

	tbegin->prev=tlab;
	code=join_tac(args, code);
	tend->prev=join_tac(tbegin, code);

	return tend;
}

SYM *mk_tmp(void)
{
	SYM *sym;
	char *name;

	name=malloc(12);
	sprintf(name, "t%d", next_tmp++); /* Set up text */
	return mk_var(name);
}

TAC *declare_para(char *name)
{
	return mk_tac(TAC_FORMAL,mk_var(name),NULL,NULL);
}

SYM *declare_func(char *name)
{
	SYM *sym=NULL;

	sym=lookup_sym(sym_tab_global,name);

	/* name used before declared */
	if(sym!=NULL)
	{
		if(sym->type==SYM_FUNC)
		{
			error("func already declared");
			return NULL;
		}

		if(sym->type !=SYM_UNDEF)
		{
			error("func name already used");
			return NULL;
		}

		return sym;
	}
	
	
	sym=mk_sym();
	sym->type=SYM_FUNC;
	sym->name=name;
	sym->address=NULL;

	insert_sym(&sym_tab_global,sym);
	return sym;
}

TAC *do_assign(SYM *var, EXP *exp)
{
	TAC *code;

	if(var->type !=SYM_VAR) error("assignment to non-variable");

	code=mk_tac(TAC_COPY, var, exp->ret, NULL);
	code->prev=exp->tac;

	return code;
}

TAC *do_input(SYM *var)
{
	TAC *code;

	if(var->type !=SYM_VAR) error("input to non-variable");

	code=mk_tac(TAC_INPUT, var, NULL, NULL);

	return code;
}

TAC *do_output(SYM *s)
{
	TAC *code;

	code=mk_tac(TAC_OUTPUT, s, NULL, NULL);

	return code;
}

EXP *do_bin( int binop, EXP *exp1, EXP *exp2)
{
	TAC *temp; /* TAC code for temp symbol */
	TAC *ret; /* TAC code for result */

	/*
	if((exp1->ret->type==SYM_INT) && (exp2->ret->type==SYM_INT))
	{
		int newval;

		switch(binop)
		{
			case TAC_ADD:
			newval=exp1->ret->value + exp2->ret->value;
			break;

			case TAC_SUB:
			newval=exp1->ret->value - exp2->ret->value;
			break;

			case TAC_MUL:
			newval=exp1->ret->value * exp2->ret->value;
			break;

			case TAC_DIV:
			newval=exp1->ret->value / exp2->ret->value;
			break;
		}

		exp1->ret=mk_const(newval);

		return exp1;
	}
	*/

	temp=mk_tac(TAC_VAR, mk_tmp(), NULL, NULL);
	temp->prev=join_tac(exp1->tac, exp2->tac);
	ret=mk_tac(binop, temp->a, exp1->ret, exp2->ret);
	ret->prev=temp;

	exp1->ret=temp->a;
	exp1->tac=ret;

	return exp1;  
}   

EXP *do_cmp( int binop, EXP *exp1, EXP *exp2)
{
	TAC *temp; /* TAC code for temp symbol */
	TAC *ret; /* TAC code for result */

	temp=mk_tac(TAC_VAR, mk_tmp(), NULL, NULL);
	temp->prev=join_tac(exp1->tac, exp2->tac);
	ret=mk_tac(binop, temp->a, exp1->ret, exp2->ret);
	ret->prev=temp;

	exp1->ret=temp->a;
	exp1->tac=ret;

	return exp1;  
}   

EXP *do_un( int unop, EXP *exp) 
{
	TAC *temp; /* TAC code for temp symbol */
	TAC *ret; /* TAC code for result */

	temp=mk_tac(TAC_VAR, mk_tmp(), NULL, NULL);
	temp->prev=exp->tac;
	ret=mk_tac(unop, temp->a, exp->ret, NULL);
	ret->prev=temp;

	exp->ret=temp->a;
	exp->tac=ret;

	return exp;   
}

TAC *do_call(char *name, EXP *arglist)
{
	EXP  *alt; /* For counting args */
	TAC *code; /* Resulting code */
	TAC *temp; /* Temporary for building code */

	code=NULL;
	for(alt=arglist; alt !=NULL; alt=alt->next) code=join_tac(code, alt->tac);

	while(arglist !=NULL) /* Generate ARG instructions */
	{
		temp=mk_tac(TAC_ACTUAL, arglist->ret, NULL, NULL);
		temp->prev=code;
		code=temp;

		alt=arglist->next;
		arglist=alt;
	};

	temp=mk_tac(TAC_CALL, NULL, (SYM *)strdup(name), NULL);
	temp->prev=code;
	code=temp;

	return code;
}

EXP *do_call_ret(char *name, EXP *arglist)
{
	EXP  *alt; /* For counting args */
	SYM *ret; /* Where function result will go */
	TAC *code; /* Resulting code */
	TAC *temp; /* Temporary for building code */

	ret=mk_tmp(); /* For the result */
	code=mk_tac(TAC_VAR, ret, NULL, NULL);

	for(alt=arglist; alt !=NULL; alt=alt->next) code=join_tac(code, alt->tac);

	while(arglist !=NULL) /* Generate ARG instructions */
	{
		temp=mk_tac(TAC_ACTUAL, arglist->ret, NULL, NULL);
		temp->prev=code;
		code=temp;

		alt=arglist->next;
		arglist=alt;
	};

	temp=mk_tac(TAC_CALL, ret, (SYM *)strdup(name), NULL);
	temp->prev=code;
	code=temp;

	return mk_exp(NULL, ret, code);
}

char *mk_lstr(int i)
{
	char lstr[10]="L";
	sprintf(lstr,"L%d",i);
	return(strdup(lstr));	
}

TAC *do_if(EXP *exp, TAC *stmt)
{
	TAC *label=mk_tac(TAC_LABEL, mk_label(mk_lstr(next_label++)), NULL, NULL);
	TAC *code=mk_tac(TAC_IFZ, label->a, exp->ret, NULL);

	code->prev=exp->tac;
	code=join_tac(code, stmt);
	label->prev=code;

	return label;
}

TAC *do_test(EXP *exp, TAC *stmt1, TAC *stmt2)
{
	TAC *label1=mk_tac(TAC_LABEL, mk_label(mk_lstr(next_label++)), NULL, NULL);
	TAC *label2=mk_tac(TAC_LABEL, mk_label(mk_lstr(next_label++)), NULL, NULL);
	TAC *code1=mk_tac(TAC_IFZ, label1->a, exp->ret, NULL);
	TAC *code2=mk_tac(TAC_GOTO, label2->a, NULL, NULL);

	code1->prev=exp->tac; /* Join the code */
	code1=join_tac(code1, stmt1);
	code2->prev=code1;
	label1->prev=code2;
	label1=join_tac(label1, stmt2);
	label2->prev=label1;
	
	return label2;
}

TAC *do_while(EXP *exp, TAC *stmt) 
{
	TAC *label=mk_tac(TAC_LABEL, mk_label(mk_lstr(next_label++)), NULL, NULL);
	TAC *code=mk_tac(TAC_GOTO, label->a, NULL, NULL);

	code->prev=stmt; /* Bolt on the goto */

	return join_tac(label, do_if(exp, code));
}

SYM *get_var(char *name)
{
	SYM *sym=NULL; /* Pointer to looked up symbol */

	if(scope) sym=lookup_sym(sym_tab_local,name);

	if(sym==NULL) sym=lookup_sym(sym_tab_global,name);

	if(sym==NULL)
	{
		error("name not declared as local/global variable");
		return NULL;
	}

	if(sym->type!=SYM_VAR)
	{
		error("not a variable");
		return NULL;
	}

	return sym;
} 

EXP *mk_exp(EXP *next, SYM *ret, TAC *code)
{
	EXP *exp=(EXP *)malloc(sizeof(EXP));

	exp->next=next;
	exp->ret=ret;
	exp->tac=code;

	return exp;
}

SYM *mk_text(char *text)
{
	SYM *sym=NULL; /* Pointer to looked up symbol */

	sym=lookup_sym(sym_tab_global,text);

	/* text already used */
	if(sym!=NULL)
	{
		return sym;
	}

	/* text unseen before */
	sym=mk_sym();
	sym->type=SYM_TEXT;
	sym->name=text;
	sym->label=next_label++;

	insert_sym(&sym_tab_global,sym);
	return sym;
}

SYM *mk_const(int n)
{
	SYM *sym=NULL;

	char name[10];
	sprintf(name, "%d", n);

	sym=lookup_sym(sym_tab_global, name);
	if(sym!=NULL)
	{
		return sym;
	}

	sym=mk_sym();
	sym->type=SYM_INT;
	sym->value=n;
	sym->name=strdup(name);
	insert_sym(&sym_tab_global,sym);

	return sym;
}     

char *to_str(SYM *s, char *str) 
{
	if(s==NULL)	return "NULL";

	switch(s->type)
	{
		case SYM_FUNC:
		case SYM_VAR:
		/* Just return the name */
		return s->name;

		case SYM_TEXT:
		/* Put the address of the text */
		sprintf(str, "L%d", s->label);
		return str;

		case SYM_INT:
		/* Convert the number to string */
		sprintf(str, "%d", s->value);
		return str;

		default:
		/* Unknown arg type */
		error("unknown TAC arg type");
		return "?";
	}
} 

void out_str(FILE *f, const char *format, ...) {
    va_list args;
    va_start(args, format);
    vfprintf(f, format, args);
    va_end(args);
}

void out_sym(FILE *f, SYM *s)
{
	out_str(f, "%p\t%s", s, s->name);
}

void out_tac(FILE *f, TAC *i)
{
	char sa[12]; /* For text of TAC args */
	char sb[12];
	char sc[12];

	switch(i->op)
	{
		case TAC_UNDEF:
		fprintf(f, "undef");
		break;

		case TAC_ADD:
		fprintf(f, "%s = %s + %s", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_SUB:
		fprintf(f, "%s = %s - %s", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_MUL:
		fprintf(f, "%s = %s * %s", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_DIV:
		fprintf(f, "%s = %s / %s", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_EQ:
		fprintf(f, "%s = (%s == %s)", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_NE:
		fprintf(f, "%s = (%s != %s)", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_LT:
		fprintf(f, "%s = (%s < %s)", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_LE:
		fprintf(f, "%s = (%s <= %s)", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_GT:
		fprintf(f, "%s = (%s > %s)", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_GE:
		fprintf(f, "%s = (%s >= %s)", to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
		break;

		case TAC_NEG:
		fprintf(f, "%s = - %s", to_str(i->a, sa), to_str(i->b, sb));
		break;

		case TAC_COPY:
		fprintf(f, "%s = %s", to_str(i->a, sa), to_str(i->b, sb));
		break;

		case TAC_GOTO:
		fprintf(f, "goto %s", i->a->name);
		break;

		case TAC_IFZ:
		fprintf(f, "ifz %s goto %s", to_str(i->b, sb), i->a->name);
		break;

		case TAC_ACTUAL:
		fprintf(f, "actual %s", to_str(i->a, sa));
		break;

		case TAC_FORMAL:
		fprintf(f, "formal %s", to_str(i->a, sa));
		break;

		case TAC_CALL:
		if(i->a==NULL) fprintf(f, "call %s", (char *)i->b);
		else fprintf(f, "%s = call %s", to_str(i->a, sa), (char *)i->b);
		break;

		case TAC_INPUT:
		fprintf(f, "input %s", to_str(i->a, sa));
		break;

		case TAC_OUTPUT:
		fprintf(f, "output %s", to_str(i->a, sa));
		break;

		case TAC_RETURN:
		fprintf(f, "return %s", to_str(i->a, sa));
		break;

		case TAC_LABEL:
		fprintf(f, "label %s", i->a->name);
		break;

		case TAC_VAR:
		fprintf(f, "var %s", to_str(i->a, sa));
		break;

		case TAC_BEGINFUNC:
		fprintf(f, "begin");
		break;

		case TAC_ENDFUNC:
		fprintf(f, "end");
		break;

		default:
		error("unknown TAC opcode");
		break;
	}
}

/* ============ CFG Implementation ============ */

static int next_bb_id = 0;

/* Create a new basic block */
static BB *new_bb(void) {
    BB *bb = (BB *)malloc(sizeof(BB));
    bb->id = next_bb_id++;
    bb->first = NULL;
    bb->last = NULL;
    bb->labels = NULL;
    bb->nlabels = 0;
    bb->succ = NULL;
    bb->pred = NULL;
    bb->next = NULL;
    return bb;
}

/* Add edge from 'from' to 'to' */
static void add_edge(BB *from, BB *to) {
    if (from == NULL || to == NULL) return;
    
    /* Add to successor list */
    ELIST *e = (ELIST *)malloc(sizeof(ELIST));
    e->block = to;
    e->next = from->succ;
    from->succ = e;
    
    /* Add to predecessor list */
    e = (ELIST *)malloc(sizeof(ELIST));
    e->block = from;
    e->next = to->pred;
    to->pred = e;
}

/* Check if instruction is a block terminator */
static int is_terminator(int op) {
    return (op == TAC_GOTO || op == TAC_IFZ || 
            op == TAC_RETURN || op == TAC_ENDFUNC);
}

/* Check if instruction starts a new block */
static int is_leader(TAC *t, TAC *prev) {
    if (t == NULL) return 0;
    
    /* First instruction after BEGINFUNC */
    if (prev == NULL || prev->op == TAC_BEGINFUNC) 
        return 1;
    
    /* Label instruction */
    if (t->op == TAC_LABEL) 
        return 1;
    
    /* Instruction after terminator */
    if (is_terminator(prev->op))
        return 1;
    
    return 0;
}

/* Find the block containing a label */
static BB *find_label_block(SYM *label) {
    if (label == NULL || label->type != SYM_LABEL) {
        error("Invalid label in jump");
        return NULL;
    }
    
    BB *bb = (BB *)label->etc;
    if (bb == NULL) {
        error("Undefined label: %s", label->name);
    }
    return bb;
}

/* Add label to block */
static void add_label_to_block(BB *bb, SYM *label) {
    bb->nlabels++;
    bb->labels = (SYM **)realloc(bb->labels, bb->nlabels * sizeof(SYM *));
    bb->labels[bb->nlabels - 1] = label;
}

/* Build CFG for one function */
CFG *build_cfg_for_func(TAC *begin_tac, TAC *end_tac) {
    if (begin_tac == NULL || end_tac == NULL) return NULL;
    if (begin_tac->op != TAC_BEGINFUNC || end_tac->op != TAC_ENDFUNC) {
        error("Invalid function boundaries");
        return NULL;
    }
    
    CFG *cfg = (CFG *)malloc(sizeof(CFG));
    cfg->func_name = "unknown";
    cfg->entry = NULL;
    cfg->list = NULL;
    cfg->nblocks = 0;
    
    /* Get function name from label before BEGINFUNC */
    if (begin_tac->prev && begin_tac->prev->op == TAC_LABEL) {
        cfg->func_name = begin_tac->prev->a->name;
    }
    
    BB *current_bb = NULL;
    BB *last_bb = NULL;
    TAC *t = begin_tac->next;  /* Skip BEGINFUNC */
    
    /* Phase 1: Create blocks and register labels */
    while (t != NULL && t != end_tac) {
        if (is_leader(t, t->prev)) {
            /* Start new block */
            current_bb = new_bb();
            current_bb->first = t;
            
            /* Link to block list */
            if (cfg->list == NULL) {
                cfg->list = current_bb;
                cfg->entry = current_bb;
            } else {
                last_bb->next = current_bb;
            }
            last_bb = current_bb;
            cfg->nblocks++;
        }
        
        /* Register label -> block mapping */
        if (t->op == TAC_LABEL) {
            if (current_bb == NULL) {
                current_bb = new_bb();
                current_bb->first = t;
                if (cfg->list == NULL) {
                    cfg->list = current_bb;
                    cfg->entry = current_bb;
                } else {
                    last_bb->next = current_bb;
                }
                last_bb = current_bb;
                cfg->nblocks++;
            }
            
            add_label_to_block(current_bb, t->a);
            t->a->etc = (void *)current_bb;  /* Store BB pointer in label */
        }
        
        /* Set last instruction of current block */
        if (current_bb) {
            current_bb->last = t;
        }
        
        t = t->next;
    }
    
    /* Phase 2: Build edges */
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        if (bb->last == NULL) continue;
        
        int op = bb->last->op;
        
        if (op == TAC_GOTO) {
            /* Unconditional jump: single successor */
            BB *target = find_label_block(bb->last->a);
            if (target) add_edge(bb, target);
            
        } else if (op == TAC_IFZ) {
            /* Conditional jump: two successors */
            BB *target = find_label_block(bb->last->a);
            if (target) add_edge(bb, target);
            
            /* Fall-through edge */
            if (bb->next) {
                add_edge(bb, bb->next);
            }
            
        } else if (op == TAC_RETURN || op == TAC_ENDFUNC) {
            /* No successors */
            
        } else {
            /* Fall-through to next block */
            if (bb->next) {
                add_edge(bb, bb->next);
            }
        }
    }
    
    return cfg;
}

/* Get TAC opcode name for printing */
static const char *get_op_name(int op) {
    switch(op) {
        case TAC_ADD: return "ADD";
        case TAC_SUB: return "SUB";
        case TAC_MUL: return "MUL";
        case TAC_DIV: return "DIV";
        case TAC_COPY: return "COPY";
        case TAC_GOTO: return "GOTO";
        case TAC_IFZ: return "IFZ";
        case TAC_LABEL: return "LABEL";
        case TAC_CALL: return "CALL";
        case TAC_RETURN: return "RETURN";
        case TAC_VAR: return "VAR";
        case TAC_FORMAL: return "FORMAL";
        case TAC_ACTUAL: return "ACTUAL";
        case TAC_INPUT: return "INPUT";
        case TAC_OUTPUT: return "OUTPUT";
        default: return "?";
    }
}

/* Format TAC instruction as string (similar to out_tac but returns string) */
void format_tac_string(TAC *i, char *buf, size_t bufsize) {
    char sa[12], sb[12], sc[12];
    
    switch(i->op) {
        case TAC_UNDEF:
            snprintf(buf, bufsize, "undef");
            break;

        case TAC_ADD:
            snprintf(buf, bufsize, "%s = %s + %s", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_SUB:
            snprintf(buf, bufsize, "%s = %s - %s", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_MUL:
            snprintf(buf, bufsize, "%s = %s * %s", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_DIV:
            snprintf(buf, bufsize, "%s = %s / %s", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_EQ:
            snprintf(buf, bufsize, "%s = (%s == %s)", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_NE:
            snprintf(buf, bufsize, "%s = (%s != %s)", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_LT:
            snprintf(buf, bufsize, "%s = (%s < %s)", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_LE:
            snprintf(buf, bufsize, "%s = (%s <= %s)", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_GT:
            snprintf(buf, bufsize, "%s = (%s > %s)", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_GE:
            snprintf(buf, bufsize, "%s = (%s >= %s)", 
                    to_str(i->a, sa), to_str(i->b, sb), to_str(i->c, sc));
            break;

        case TAC_NEG:
            snprintf(buf, bufsize, "%s = - %s", 
                    to_str(i->a, sa), to_str(i->b, sb));
            break;

        case TAC_COPY:
            snprintf(buf, bufsize, "%s = %s", 
                    to_str(i->a, sa), to_str(i->b, sb));
            break;

        case TAC_GOTO:
            snprintf(buf, bufsize, "goto %s", i->a->name);
            break;

        case TAC_IFZ:
            snprintf(buf, bufsize, "ifz %s goto %s", 
                    to_str(i->b, sb), i->a->name);
            break;

        case TAC_ACTUAL:
            snprintf(buf, bufsize, "actual %s", to_str(i->a, sa));
            break;

        case TAC_FORMAL:
            snprintf(buf, bufsize, "formal %s", to_str(i->a, sa));
            break;

        case TAC_CALL:
            if(i->a == NULL) 
                snprintf(buf, bufsize, "call %s", (char *)i->b);
            else 
                snprintf(buf, bufsize, "%s = call %s", 
                        to_str(i->a, sa), (char *)i->b);
            break;

        case TAC_INPUT:
            snprintf(buf, bufsize, "input %s", to_str(i->a, sa));
            break;

        case TAC_OUTPUT:
            snprintf(buf, bufsize, "output %s", to_str(i->a, sa));
            break;

        case TAC_RETURN:
            snprintf(buf, bufsize, "return %s", to_str(i->a, sa));
            break;

        case TAC_LABEL:
            snprintf(buf, bufsize, "%s:", i->a->name);
            break;

        case TAC_VAR:
            snprintf(buf, bufsize, "var %s", to_str(i->a, sa));
            break;

        case TAC_BEGINFUNC:
            snprintf(buf, bufsize, "begin");
            break;

        case TAC_ENDFUNC:
            snprintf(buf, bufsize, "end");
            break;

        default:
            snprintf(buf, bufsize, "unknown op %d", i->op);
            break;
    }
}


/* Print CFG in DOT format with full instructions */
void print_cfg_dot(CFG *cfg, FILE *out) {
    if (cfg == NULL) return;
    
    fprintf(out, "\n/* CFG for function %s */\n", cfg->func_name);
    fprintf(out, "digraph CFG_%s {\n", cfg->func_name);
    fprintf(out, "    node [shape=box, fontname=\"Courier\", fontsize=10];\n");
    fprintf(out, "    edge [fontname=\"Courier\"];\n\n");
    
    /* Print nodes with full instruction listing */
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        fprintf(out, "    bb%d [label=\"", bb->id);
        
        /* Block header with ID */
        fprintf(out, "BB%d", bb->id);
        
        /* Add labels if any */
        if (bb->nlabels > 0) {
            fprintf(out, " [");
            for (int i = 0; i < bb->nlabels; i++) {
                if (i > 0) fprintf(out, ", ");
                fprintf(out, "%s", bb->labels[i]->name);
            }
            fprintf(out, "]");
        }
        
        fprintf(out, "\n");
        fprintf(out, "─────────────────\n");
        
        /* Print all instructions in the block */
        TAC *t = bb->first;
        int inst_count = 0;
        while (t != NULL) {
            char line[256];
            
            /* Format instruction into string */
            format_tac_string(t, line, sizeof(line));
            
            /* Escape special characters for DOT format */
            char *p = line;
            while (*p) {
                if (*p == '"') fprintf(out, "\\\"");
                else if (*p == '\\') fprintf(out, "\\\\");
                else if (*p == '\n') fprintf(out, "\n");
                else fputc(*p, out);
                p++;
            }
            
            fprintf(out, "\n");
            inst_count++;
            
            /* Stop at last instruction of block */
            if (t == bb->last) break;
            t = t->next;
        }
        
        fprintf(out, "\"];\n");
    }
    
    fprintf(out, "\n");
    
    /* Print edges */
    for (BB *bb = cfg->list; bb != NULL; bb = bb->next) {
        for (ELIST *e = bb->succ; e != NULL; e = e->next) {
            /* Label edge type */
            const char *label = "";
            if (bb->last && bb->last->op == TAC_IFZ) {
                BB *jump_target = find_label_block(bb->last->a);
                if (e->block == jump_target) {
                    label = " [label=\"true\", color=\"red\"]";
                } else {
                    label = " [label=\"false\", color=\"blue\"]";
                }
            }
            
            fprintf(out, "    bb%d -> bb%d%s;\n", 
                    bb->id, e->block->id, label);
        }
    }
    
    fprintf(out, "}\n");
}


/* Build and print CFG for all functions */
void build_and_print_all_cfg(FILE *out) {
    TAC *t = tac_first;
    
    fprintf(out, "\n/* ========== Control Flow Graphs ========== */\n");
    
    while (t != NULL) {
        if (t->op == TAC_BEGINFUNC) {
            /* Find matching ENDFUNC */
            TAC *begin = t;
            TAC *end = t->next;
            
            while (end != NULL && end->op != TAC_ENDFUNC) {
                end = end->next;
            }
            
            if (end == NULL) {
                error("BEGINFUNC without matching ENDFUNC");
                break;
            }
            
            /* Build and print CFG */
            CFG *cfg = build_cfg_for_func(begin, end);
            if (cfg) {
                print_cfg_dot(cfg, out);
                free_cfg(cfg);
            }
            
            t = end->next;
        } else {
            t = t->next;
        }
    }
    
    /* Reset BB ID counter for next compilation */
    next_bb_id = 0;
}

/* Free CFG memory */
void free_cfg(CFG *cfg) {
    if (cfg == NULL) return;
    
    BB *bb = cfg->list;
    while (bb != NULL) {
        BB *next_bb = bb->next;
        
        /* Free edge lists */
        ELIST *e = bb->succ;
        while (e != NULL) {
            ELIST *next_e = e->next;
            free(e);
            e = next_e;
        }
        
        e = bb->pred;
        while (e != NULL) {
            ELIST *next_e = e->next;
            free(e);
            e = next_e;
        }
        
        /* Free label array */
        if (bb->labels) free(bb->labels);
        
        free(bb);
        bb = next_bb;
    }
    
    free(cfg);
}