
# Original TAC

# tac list

0x634f508a8230	label main
0x634f508a8270	begin
0x634f508a77d0	var a
0x634f508a7870	var b
0x634f508a7910	var c
0x634f508a79b0	var d
0x634f508a7bd0	var t0
0x634f508a7c10	t0 = 1 + 2
0x634f508a7c50	a = t0
0x634f508a7e10	var t1
0x634f508a7e50	t1 = a * 3
0x634f508a7e90	b = t1
0x634f508a7ff0	var t2
0x634f508a8030	t2 = 3 * 3
0x634f508a8070	c = t2
0x634f508a80d0	output a
0x634f508a8130	output b
0x634f508a8190	output c
0x634f508a82b0	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 3 iterations */

# Optimized TAC

# tac list

0x634f508a8230	label main
0x634f508a8270	begin
0x634f508a77d0	var a
0x634f508a7870	var b
0x634f508a7910	var c
0x634f508a79b0	var d
0x634f508a7bd0	var t0
0x634f508a7c50	a = 3
0x634f508a7e10	var t1
0x634f508a7e90	b = 9
0x634f508a7ff0	var t2
0x634f508a8070	c = 9
0x634f508a80d0	output a
0x634f508a8130	output b
0x634f508a8190	output c
0x634f508a82b0	end

/* ========== Control Flow Graphs ========== */

/* CFG for function main */
digraph CFG_main {
    node [shape=box, fontname="Courier", fontsize=10];
    edge [fontname="Courier"];

    bb0 [label="BB0
─────────────────
var a
var b
var c
var d
var t0
a = 3
var t1
b = 9
var t2
c = 9
output a
output b
output c
"];

}
