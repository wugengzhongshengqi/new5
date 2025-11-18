
# Original TAC

# tac list

0x558fe77bfb10	label main
0x558fe77bfb50	begin
0x558fe77be7d0	var x
0x558fe77be870	var y
0x558fe77be910	var z
0x558fe77be9b0	var c
0x558fe77bea50	var d
0x558fe77beaf0	var a
0x558fe77beb90	var b
0x558fe77bedb0	var t0
0x558fe77bedf0	t0 = 2 + 3
0x558fe77bee30	x = t0
0x558fe77beff0	var t1
0x558fe77bf030	t1 = x * 1
0x558fe77bf070	y = t1
0x558fe77bf230	var t2
0x558fe77bf270	t2 = y + 0
0x558fe77bf2b0	z = t2
0x558fe77bf3c0	c = 10
0x558fe77bf470	d = c
0x558fe77bf630	var t3
0x558fe77bf670	t3 = 5 / 1
0x558fe77bf6b0	a = t3
0x558fe77bf870	var t4
0x558fe77bf8b0	t4 = 0 * 100
0x558fe77bf8f0	b = t4
0x558fe77bf950	output z
0x558fe77bf9b0	output d
0x558fe77bfa10	output a
0x558fe77bfa70	output b
0x558fe77bfb90	end

/* ========== Local Optimizations ========== */

/* Optimizing function main */
/* main: 2 iterations, optimized */

# Optimized TAC

# tac list

0x558fe77bfb10	label main
0x558fe77bfb50	begin
0x558fe77be7d0	var x
0x558fe77be870	var y
0x558fe77be910	var z
0x558fe77be9b0	var c
0x558fe77bea50	var d
0x558fe77beaf0	var a
0x558fe77beb90	var b
0x558fe77bedb0	var t0
0x558fe77bedf0	t0 = 5
0x558fe77bee30	x = t0
0x558fe77beff0	var t1
0x558fe77bf030	t1 = x
0x558fe77bf070	y = t1
0x558fe77bf230	var t2
0x558fe77bf270	t2 = y
0x558fe77bf2b0	z = t2
0x558fe77bf3c0	c = 10
0x558fe77bf470	d = c
0x558fe77bf630	var t3
0x558fe77bf670	t3 = 5
0x558fe77bf6b0	a = t3
0x558fe77bf870	var t4
0x558fe77bf8b0	t4 = 0
0x558fe77bf8f0	b = t4
0x558fe77bf950	output z
0x558fe77bf9b0	output d
0x558fe77bfa10	output a
0x558fe77bfa70	output b
0x558fe77bfb90	end

/* ========== Control Flow Graphs ========== */

/* CFG for function main */
digraph CFG_main {
    node [shape=box, fontname="Courier", fontsize=10];
    edge [fontname="Courier"];

    bb1 [label="BB1
─────────────────
var x
var y
var z
var c
var d
var a
var b
var t0
t0 = 5
x = t0
var t1
t1 = x
y = t1
var t2
t2 = y
z = t2
c = 10
d = c
var t3
t3 = 5
a = t3
var t4
t4 = 0
b = t4
output z
output d
output a
output b
"];

}
