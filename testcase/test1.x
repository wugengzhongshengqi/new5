
# Original TAC

# tac list

0x561df1151180	label main
0x561df11511c0	begin
0x561df114f7d0	var a
0x561df114f870	var b
0x561df114f910	var c
0x561df114f9b0	var d
0x561df114fa50	var e
0x561df114faf0	var f
0x561df114fb90	var g
0x561df114fc30	var h
0x561df114fe50	var t0
0x561df114fe90	t0 = 2 + 3
0x561df114fed0	a = t0
0x561df11500f0	var t1
0x561df1150130	t1 = 10 - 4
0x561df1150170	b = t1
0x561df1150390	var t2
0x561df11503d0	t2 = 6 * 7
0x561df1150410	c = t2
0x561df1150630	var t3
0x561df1150670	t3 = 20 / 5
0x561df11506b0	d = t3
0x561df11507c0	var t4
0x561df1150800	t4 = - 10
0x561df1150840	e = t4
0x561df11509a0	var t5
0x561df11509e0	t5 = (3 > 2)
0x561df1150a20	f = t5
0x561df1150b80	var t6
0x561df1150bc0	t6 = (5 == 5)
0x561df1150c00	g = t6
0x561df1150d60	var t7
0x561df1150da0	t7 = (4 < 3)
0x561df1150de0	h = t7
0x561df1150e40	output a
0x561df1150ea0	output b
0x561df1150f00	output c
0x561df1150f60	output d
0x561df1150fc0	output e
0x561df1151020	output f
0x561df1151080	output g
0x561df11510e0	output h
0x561df1151200	end

/* ========== Local Optimizations ========== */

/* Optimizing function main */
/* main: 2 iterations, optimized */

# Optimized TAC

# tac list

0x561df1151180	label main
0x561df11511c0	begin
0x561df114f7d0	var a
0x561df114f870	var b
0x561df114f910	var c
0x561df114f9b0	var d
0x561df114fa50	var e
0x561df114faf0	var f
0x561df114fb90	var g
0x561df114fc30	var h
0x561df114fe50	var t0
0x561df114fe90	t0 = 5
0x561df114fed0	a = t0
0x561df11500f0	var t1
0x561df1150130	t1 = 6
0x561df1150170	b = t1
0x561df1150390	var t2
0x561df11503d0	t2 = 42
0x561df1150410	c = t2
0x561df1150630	var t3
0x561df1150670	t3 = 4
0x561df11506b0	d = t3
0x561df11507c0	var t4
0x561df1150800	t4 = -10
0x561df1150840	e = t4
0x561df11509a0	var t5
0x561df11509e0	t5 = 1
0x561df1150a20	f = t5
0x561df1150b80	var t6
0x561df1150bc0	t6 = 1
0x561df1150c00	g = t6
0x561df1150d60	var t7
0x561df1150da0	t7 = 0
0x561df1150de0	h = t7
0x561df1150e40	output a
0x561df1150ea0	output b
0x561df1150f00	output c
0x561df1150f60	output d
0x561df1150fc0	output e
0x561df1151020	output f
0x561df1151080	output g
0x561df11510e0	output h
0x561df1151200	end

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
var e
var f
var g
var h
var t0
t0 = 5
a = t0
var t1
t1 = 6
b = t1
var t2
t2 = 42
c = t2
var t3
t3 = 4
d = t3
var t4
t4 = -10
e = t4
var t5
t5 = 1
f = t5
var t6
t6 = 1
g = t6
var t7
t7 = 0
h = t7
output a
output b
output c
output d
output e
output f
output g
output h
"];

}
