
# Original TAC

# tac list

0x5e0745b12da0	label main
0x5e0745b12de0	begin
0x5e0745b127d0	var a
0x5e0745b12c60	ifz 1 goto L1
0x5e0745b12990	a = 10
0x5e0745b12ca0	goto L2
0x5e0745b12b60	label L1
0x5e0745b12aa0	a = 20
0x5e0745b12c20	label L2
0x5e0745b12d00	output a
0x5e0745b12e20	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 2 iterations */

# Optimized TAC

# tac list

0x5e0745b12da0	label main
0x5e0745b12de0	begin
0x5e0745b127d0	var a
0x5e0745b12990	a = 10
0x5e0745b12ca0	goto L2
0x5e0745b12c20	label L2
0x5e0745b12d00	output a
0x5e0745b12e20	end

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
