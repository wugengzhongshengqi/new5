
# Original TAC

# tac list

0x5f6b65d55440	label main
0x5f6b65d55480	begin
0x5f6b65d537d0	var a
0x5f6b65d53870	var b
0x5f6b65d53910	var c
0x5f6b65d539b0	var d
0x5f6b65d53a50	var e
0x5f6b65d53af0	var x
0x5f6b65d53b90	var y
0x5f6b65d53c30	var z
0x5f6b65d53cd0	var i
0x5f6b65d53d30	input a
0x5f6b65d53d90	input b
0x5f6b65d53df0	input x
0x5f6b65d53e50	input y
0x5f6b65d53fb0	var t0
0x5f6b65d53ff0	t0 = a + b
0x5f6b65d54030	c = t0
0x5f6b65d54090	output c
0x5f6b65d541a0	i = 0
0x5f6b65d55020	label L2
0x5f6b65d54340	var t1
0x5f6b65d54380	t1 = (i < 5)
0x5f6b65d55160	ifz t1 goto L3
0x5f6b65d544e0	var t2
0x5f6b65d54520	t2 = a + b
0x5f6b65d54560	d = t2
0x5f6b65d546c0	var t3
0x5f6b65d54700	t3 = x * y
0x5f6b65d54740	z = t3
0x5f6b65d547a0	output d
0x5f6b65d54800	output z
0x5f6b65d549a0	var t4
0x5f6b65d549e0	t4 = (i > 2)
0x5f6b65d54d40	ifz t4 goto L1
0x5f6b65d54b40	var t5
0x5f6b65d54b80	t5 = x * y
0x5f6b65d54bc0	e = t5
0x5f6b65d54c20	output e
0x5f6b65d54d00	label L1
0x5f6b65d54ee0	var t6
0x5f6b65d54f20	t6 = i + 1
0x5f6b65d54f60	i = t6
0x5f6b65d55060	goto L2
0x5f6b65d55120	label L3
0x5f6b65d552c0	var t7
0x5f6b65d55300	t7 = a + b
0x5f6b65d55340	e = t7
0x5f6b65d553a0	output e
0x5f6b65d554c0	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 3 iterations */

# Optimized TAC

# tac list

0x5f6b65d55440	label main
0x5f6b65d55480	begin
0x5f6b65d537d0	var a
0x5f6b65d53870	var b
0x5f6b65d53910	var c
0x5f6b65d539b0	var d
0x5f6b65d53a50	var e
0x5f6b65d53af0	var x
0x5f6b65d53b90	var y
0x5f6b65d53c30	var z
0x5f6b65d53cd0	var i
0x5f6b65d53d30	input a
0x5f6b65d53d90	input b
0x5f6b65d53df0	input x
0x5f6b65d53e50	input y
0x5f6b65d53fb0	var t0
0x5f6b65d53ff0	t0 = a + b
0x5f6b65d54030	c = t0
0x5f6b65d54090	output c
0x5f6b65d541a0	i = 0
0x5f6b65d55020	label L2
0x5f6b65d54340	var t1
0x5f6b65d54380	t1 = (i < 5)
0x5f6b65d55160	ifz t1 goto L3
0x5f6b65d544e0	var t2
0x5f6b65d54520	t2 = a + b
0x5f6b65d54560	d = t2
0x5f6b65d546c0	var t3
0x5f6b65d54700	t3 = x * y
0x5f6b65d54740	z = t3
0x5f6b65d547a0	output d
0x5f6b65d54800	output z
0x5f6b65d549a0	var t4
0x5f6b65d549e0	t4 = (i > 2)
0x5f6b65d54d40	ifz t4 goto L1
0x5f6b65d54b40	var t5
0x5f6b65d54bc0	e = t3
0x5f6b65d54c20	output e
0x5f6b65d54d00	label L1
0x5f6b65d54ee0	var t6
0x5f6b65d54f20	t6 = i + 1
0x5f6b65d54f60	i = t6
0x5f6b65d55060	goto L2
0x5f6b65d55120	label L3
0x5f6b65d552c0	var t7
0x5f6b65d55300	t7 = a + b
0x5f6b65d55340	e = t7
0x5f6b65d553a0	output e
0x5f6b65d554c0	end

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
var e
var x
var y
var z
var i
input a
input b
input x
input y
var t0
t0 = a + b
c = t0
output c
i = 0
"];
    bb1 [label="BB1 [L2]
─────────────────
L2:
var t1
t1 = (i < 5)
ifz t1 goto L3
"];
    bb2 [label="BB2
─────────────────
var t2
t2 = a + b
d = t2
var t3
t3 = x * y
z = t3
output d
output z
var t4
t4 = (i > 2)
ifz t4 goto L1
"];
    bb3 [label="BB3
─────────────────
var t5
e = t3
output e
"];
    bb4 [label="BB4 [L1]
─────────────────
L1:
var t6
t6 = i + 1
i = t6
goto L2
"];
    bb5 [label="BB5 [L3]
─────────────────
L3:
var t7
t7 = a + b
e = t7
output e
"];

    bb0 -> bb1;
    bb1 -> bb2 [label="false", color="blue"];
    bb1 -> bb5 [label="true", color="red"];
    bb2 -> bb3 [label="false", color="blue"];
    bb2 -> bb4 [label="true", color="red"];
    bb3 -> bb4;
    bb4 -> bb1;
}
