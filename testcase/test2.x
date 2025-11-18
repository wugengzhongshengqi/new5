
# Original TAC

# tac list

0x5613d5ced940	label main
0x5613d5ced980	begin
0x5613d5cec7d0	var x
0x5613d5cec870	var y
0x5613d5cec910	var z
0x5613d5cec9b0	var a
0x5613d5ceca50	var b
0x5613d5cecaf0	var c
0x5613d5cecb90	var d
0x5613d5cecca0	x = 100
0x5613d5cece60	var t0
0x5613d5cecea0	t0 = x + 0
0x5613d5cecee0	y = t0
0x5613d5ced040	var t1
0x5613d5ced080	t1 = 0 + x
0x5613d5ced0c0	z = t1
0x5613d5ced220	var t2
0x5613d5ced260	t2 = x - 0
0x5613d5ced2a0	a = t2
0x5613d5ced460	var t3
0x5613d5ced4a0	t3 = x * 1
0x5613d5ced4e0	b = t3
0x5613d5ced640	var t4
0x5613d5ced680	t4 = 1 * x
0x5613d5ced6c0	c = t4
0x5613d5ced820	var t5
0x5613d5ced860	t5 = x / 1
0x5613d5ced8a0	d = t5
0x5613d5ced9c0	end

/* ========== Local Optimizations ========== */

/* Optimizing function main */
/* main: 2 iterations, optimized */

# Optimized TAC

# tac list

0x5613d5ced940	label main
0x5613d5ced980	begin
0x5613d5cec7d0	var x
0x5613d5cec870	var y
0x5613d5cec910	var z
0x5613d5cec9b0	var a
0x5613d5ceca50	var b
0x5613d5cecaf0	var c
0x5613d5cecb90	var d
0x5613d5cecca0	x = 100
0x5613d5cece60	var t0
0x5613d5cecea0	t0 = x
0x5613d5cecee0	y = t0
0x5613d5ced040	var t1
0x5613d5ced080	t1 = x
0x5613d5ced0c0	z = t1
0x5613d5ced220	var t2
0x5613d5ced260	t2 = x
0x5613d5ced2a0	a = t2
0x5613d5ced460	var t3
0x5613d5ced4a0	t3 = x
0x5613d5ced4e0	b = t3
0x5613d5ced640	var t4
0x5613d5ced680	t4 = x
0x5613d5ced6c0	c = t4
0x5613d5ced820	var t5
0x5613d5ced860	t5 = x
0x5613d5ced8a0	d = t5
0x5613d5ced9c0	end

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
var a
var b
var c
var d
x = 100
var t0
t0 = x
y = t0
var t1
t1 = x
z = t1
var t2
t2 = x
a = t2
var t3
t3 = x
b = t3
var t4
t4 = x
c = t4
var t5
t5 = x
d = t5
"];

}
