
# Original TAC

# tac list

0x59c680dfdda0	label main
0x59c680dfdde0	begin
0x59c680dfd7d0	var a
0x59c680dfdc60	ifz 1 goto L1
0x59c680dfd990	a = 10
0x59c680dfdca0	goto L2
0x59c680dfdb60	label L1
0x59c680dfdaa0	a = 20
0x59c680dfdc20	label L2
0x59c680dfdd00	output a
0x59c680dfde20	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 2 iterations */

# Optimized TAC

# tac list

0x59c680dfdda0	label main
0x59c680dfdde0	begin
0x59c680dfd7d0	var a
0x59c680dfd990	a = 10
0x59c680dfdca0	goto L2
0x59c680dfdc20	label L2
0x59c680dfdd00	output a
0x59c680dfde20	end

/* ========== Control Flow Graphs ========== */

/* CFG for function main */
digraph CFG_main {
    node [shape=box, fontname="Courier", fontsize=10];
    edge [fontname="Courier"];

    bb0 [label="BB0
─────────────────
var a
a = 10
goto L2
"];
    bb1 [label="BB1 [L2]
─────────────────
L2:
output a
"];

    bb0 -> bb1;
}
