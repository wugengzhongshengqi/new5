
# Original TAC

# tac list

0x5de32021feb0	label main
0x5de32021fef0	begin
0x5de32021d7d0	var a
0x5de32021d870	var b
0x5de32021d910	var c
0x5de32021d9b0	var d
0x5de32021da50	var e
0x5de32021daf0	var i
0x5de32021db90	var j
0x5de32021dc30	var k
0x5de32021dc90	input a
0x5de32021dcf0	input b
0x5de32021dd50	input c
0x5de32021de60	j = 5
0x5de32021fab0	label L4
0x5de32021e000	var t0
0x5de32021e040	t0 = (j > 0)
0x5de32021fbf0	ifz t0 goto L5
0x5de32021e0a0	output j
0x5de32021e1b0	i = 9
0x5de32021f630	label L1
0x5de32021e2f0	var t1
0x5de32021e330	t1 = (i > 0)
0x5de32021f770	ifz t1 goto L2
0x5de32021e390	output i
0x5de32021e540	var t2
0x5de32021e580	t2 = b * c
0x5de32021e620	var t3
0x5de32021e660	t3 = a + t2
0x5de32021e7a0	var t4
0x5de32021e7e0	t4 = a + c
0x5de32021e8d0	var t5
0x5de32021e910	t5 = t4 / b
0x5de32021e9b0	var t6
0x5de32021e9f0	t6 = t3 - t5
0x5de32021eae0	var t7
0x5de32021eb20	t7 = t6 + 9
0x5de32021eb60	d = t7
0x5de32021ed10	var t8
0x5de32021ed50	t8 = b * c
0x5de32021edf0	var t9
0x5de32021ee30	t9 = a + t8
0x5de32021ef70	var t10
0x5de32021efb0	t10 = c - a
0x5de32021f0a0	var t11
0x5de32021f0e0	t11 = t10 / b
0x5de32021f180	var t12
0x5de32021f1c0	t12 = t9 - t11
0x5de32021f2b0	var t13
0x5de32021f2f0	t13 = t12 + 9
0x5de32021f330	e = t13
0x5de32021f4f0	var t14
0x5de32021f530	t14 = i - 1
0x5de32021f570	i = t14
0x5de32021f670	goto L1
0x5de32021f730	label L2
0x5de32021f8d0	var t15
0x5de32021f910	t15 = j - 1
0x5de32021f950	j = t15
0x5de32021f9f0	output L3
0x5de32021faf0	goto L4
0x5de32021fbb0	label L5
0x5de32021fc90	output L6
0x5de32021fcf0	output d
0x5de32021fd50	output L3
0x5de32021fdb0	output e
0x5de32021fe10	output L6
0x5de32021ff30	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 2 iterations */

# Optimized TAC

# tac list

0x5de32021feb0	label main
0x5de32021fef0	begin
0x5de32021d7d0	var a
0x5de32021d870	var b
0x5de32021d910	var c
0x5de32021d9b0	var d
0x5de32021da50	var e
0x5de32021daf0	var i
0x5de32021db90	var j
0x5de32021dc30	var k
0x5de32021e000	var t0
0x5de32021e2f0	var t1
0x5de32021e540	var t2
0x5de32021e620	var t3
0x5de32021e7a0	var t4
0x5de32021e8d0	var t5
0x5de32021e9b0	var t6
0x5de32021eae0	var t7
0x5de32021ed10	var t8
0x5de32021edf0	var t9
0x5de32021ef70	var t10
0x5de32021f0a0	var t11
0x5de32021f180	var t12
0x5de32021f2b0	var t13
0x5de32021f4f0	var t14
0x5de32021f8d0	var t15
0x5de32021dc90	input a
0x5de32021dcf0	input b
0x5de32021dd50	input c
0x5de32021de60	j = 5
0x5de32021e580	t2 = b * c
0x5de32021e660	t3 = a + t2
0x5de32021e7e0	t4 = a + c
0x5de32021e910	t5 = t4 / b
0x5de32021e9f0	t6 = t3 - t5
0x5de32021eb20	t7 = 9 + t6
0x5de32021eb60	d = t7
0x5de32021ed50	t8 = t2
0x5de32021ee30	t9 = t3
0x5de32021efb0	t10 = c - a
0x5de32021f0e0	t11 = t10 / b
0x5de32021f1c0	t12 = t9 - t11
0x5de32021f2f0	t13 = 9 + t12
0x5de32021f330	e = t13
0x5de32021fab0	label L4
0x5de32021e040	t0 = (j > 0)
0x5de32021fbf0	ifz t0 goto L5
0x5de32021e0a0	output j
0x5de32021e1b0	i = 9
0x5de32021f630	label L1
0x5de32021e330	t1 = (i > 0)
0x5de32021f770	ifz t1 goto L2
0x5de32021e390	output i
0x5de32021f530	t14 = i - 1
0x5de32021f570	i = t14
0x5de32021f670	goto L1
0x5de32021f730	label L2
0x5de32021f910	t15 = j - 1
0x5de32021f950	j = t15
0x5de32021f9f0	output L3
0x5de32021faf0	goto L4
0x5de32021fbb0	label L5
0x5de32021fc90	output L6
0x5de32021fcf0	output d
0x5de32021fd50	output L3
0x5de32021fdb0	output e
0x5de32021fe10	output L6
0x5de32021ff30	end

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
var i
var j
var k
var t0
var t1
var t2
var t3
var t4
var t5
var t6
var t7
var t8
var t9
var t10
var t11
var t12
var t13
var t14
var t15
input a
input b
input c
j = 5
t2 = b * c
t3 = a + t2
t4 = a + c
t5 = t4 / b
t6 = t3 - t5
t7 = 9 + t6
d = t7
t8 = t2
t9 = t3
t10 = c - a
t11 = t10 / b
t12 = t9 - t11
t13 = 9 + t12
e = t13
"];
    bb1 [label="BB1 [L4]
─────────────────
L4:
t0 = (j > 0)
ifz t0 goto L5
"];
    bb2 [label="BB2
─────────────────
output j
i = 9
"];
    bb3 [label="BB3 [L1]
─────────────────
L1:
t1 = (i > 0)
ifz t1 goto L2
"];
    bb4 [label="BB4
─────────────────
output i
t14 = i - 1
i = t14
goto L1
"];
    bb5 [label="BB5 [L2]
─────────────────
L2:
t15 = j - 1
j = t15
output L3
goto L4
"];
    bb6 [label="BB6 [L5]
─────────────────
L5:
output L6
output d
output L3
output e
output L6
"];

    bb0 -> bb1;
    bb1 -> bb2 [label="false", color="blue"];
    bb1 -> bb6 [label="true", color="red"];
    bb2 -> bb3;
    bb3 -> bb4 [label="false", color="blue"];
    bb3 -> bb5 [label="true", color="red"];
    bb4 -> bb3;
    bb5 -> bb1;
}
