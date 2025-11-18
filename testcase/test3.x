
# Original TAC

# tac list

0x63b2d3a161f0	label main
0x63b2d3a16230	begin
0x63b2d3a157d0	var a
0x63b2d3a15870	var b
0x63b2d3a15910	var c
0x63b2d3a159b0	var d
0x63b2d3a15ac0	a = 5
0x63b2d3a15c80	var t0
0x63b2d3a15cc0	t0 = a * 0
0x63b2d3a15d00	b = t0
0x63b2d3a15e60	var t1
0x63b2d3a15ea0	t1 = 0 * a
0x63b2d3a15ee0	c = t1
0x63b2d3a16040	var t2
0x63b2d3a16080	t2 = 0 / a
0x63b2d3a160c0	d = t2
0x63b2d3a16150	return d
0x63b2d3a16270	end

/* ========== Local Optimizations ========== */

/* Optimizing function main */
/* main: 2 iterations, optimized */

# Optimized TAC

# tac list

0x63b2d3a161f0	label main
0x63b2d3a16230	begin
0x63b2d3a157d0	var a
0x63b2d3a15870	var b
0x63b2d3a15910	var c
0x63b2d3a159b0	var d
0x63b2d3a15ac0	a = 5
0x63b2d3a15c80	var t0
0x63b2d3a15cc0	t0 = 0
0x63b2d3a15d00	b = t0
0x63b2d3a15e60	var t1
0x63b2d3a15ea0	t1 = 0
0x63b2d3a15ee0	c = t1
0x63b2d3a16040	var t2
0x63b2d3a16080	t2 = 0
0x63b2d3a160c0	d = t2
0x63b2d3a16150	return d
0x63b2d3a16270	end

/* ========== Control Flow Graphs ========== */

/* CFG for function main */
digraph CFG_main {
    node [shape=box, fontname="Courier", fontsize=10];
    edge [fontname="Courier"];

    bb1 [label="BB1
─────────────────
var a
var b
var c
var d
a = 5
var t0
t0 = 0
b = t0
var t1
t1 = 0
c = t1
var t2
t2 = 0
d = t2
return d
"];

}
