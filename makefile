all: mini asm machine

mini: main.c mini.l mini.y tac.c tac.h obj.c obj.h optimize.c
	lex -o mini.l.c mini.l
	yacc -d -o mini.y.c mini.y
	gcc -g3 main.c mini.l.c mini.y.c tac.c obj.c optimize.c -o mini

asm: asm.l asm.y inst.h
	lex -o asm.l.c asm.l
	yacc -d -o asm.y.c asm.y
	gcc -g3 asm.l.c asm.y.c -o asm

machine: machine.c inst.h
	gcc -g3 machine.c -o machine

clean:
	rm -fr *.l.* *.y.* *.s *.x *.o core mini asm machine

test-%:
	./mini testcase/$*.m; \
	./asm testcase/$*.s; \
	./machine testcase/$*.o

# 新增：仅运行编译器测试（不运行汇编器和机器）
test-opt-%:
	./mini testcase/$*.m
	@echo "=== Original TAC ==="
	@grep -A 1000 "# Original TAC" testcase/$*.x | grep -B 1000 "# Optimized TAC" | head -n -1
	@echo ""
	@echo "=== Optimized TAC ==="
	@grep -A 1000 "# Optimized TAC" testcase/$*.x | grep -B 1000 "Control Flow Graphs" | head -n -1

.PHONY: all clean test-% test-opt-%