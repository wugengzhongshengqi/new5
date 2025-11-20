
# Original TAC

# tac list

0x5b1f0f429eb0	label main
0x5b1f0f429ef0	begin
0x5b1f0f4277d0	var a
0x5b1f0f427870	var b
0x5b1f0f427910	var c
0x5b1f0f4279b0	var d
0x5b1f0f427a50	var e
0x5b1f0f427af0	var i
0x5b1f0f427b90	var j
0x5b1f0f427c30	var k
0x5b1f0f427c90	input a
0x5b1f0f427cf0	input b
0x5b1f0f427d50	input c
0x5b1f0f427e60	j = 5
0x5b1f0f429ab0	label L4
0x5b1f0f428000	var t0
0x5b1f0f428040	t0 = (j > 0)
0x5b1f0f429bf0	ifz t0 goto L5
0x5b1f0f4280a0	output j
0x5b1f0f4281b0	i = 9
0x5b1f0f429630	label L1
0x5b1f0f4282f0	var t1
0x5b1f0f428330	t1 = (i > 0)
0x5b1f0f429770	ifz t1 goto L2
0x5b1f0f428390	output i
0x5b1f0f428540	var t2
0x5b1f0f428580	t2 = b * c
0x5b1f0f428620	var t3
0x5b1f0f428660	t3 = a + t2
0x5b1f0f4287a0	var t4
0x5b1f0f4287e0	t4 = a + c
0x5b1f0f4288d0	var t5
0x5b1f0f428910	t5 = t4 / b
0x5b1f0f4289b0	var t6
0x5b1f0f4289f0	t6 = t3 - t5
0x5b1f0f428ae0	var t7
0x5b1f0f428b20	t7 = t6 + 9
0x5b1f0f428b60	d = t7
0x5b1f0f428d10	var t8
0x5b1f0f428d50	t8 = b * c
0x5b1f0f428df0	var t9
0x5b1f0f428e30	t9 = a + t8
0x5b1f0f428f70	var t10
0x5b1f0f428fb0	t10 = c - a
0x5b1f0f4290a0	var t11
0x5b1f0f4290e0	t11 = t10 / b
0x5b1f0f429180	var t12
0x5b1f0f4291c0	t12 = t9 - t11
0x5b1f0f4292b0	var t13
0x5b1f0f4292f0	t13 = t12 + 9
0x5b1f0f429330	e = t13
0x5b1f0f4294f0	var t14
0x5b1f0f429530	t14 = i - 1
0x5b1f0f429570	i = t14
0x5b1f0f429670	goto L1
0x5b1f0f429730	label L2
0x5b1f0f4298d0	var t15
0x5b1f0f429910	t15 = j - 1
0x5b1f0f429950	j = t15
0x5b1f0f4299f0	output L3
0x5b1f0f429af0	goto L4
0x5b1f0f429bb0	label L5
0x5b1f0f429c90	output L6
0x5b1f0f429cf0	output d
0x5b1f0f429d50	output L3
0x5b1f0f429db0	output e
0x5b1f0f429e10	output L6
0x5b1f0f429f30	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 2 iterations */

# Optimized TAC

# tac list

0x5b1f0f429eb0	label main
0x5b1f0f429ef0	begin
0x5b1f0f4277d0	var a
0x5b1f0f427870	var b
0x5b1f0f427910	var c
0x5b1f0f4279b0	var d
0x5b1f0f427a50	var e
0x5b1f0f427af0	var i
0x5b1f0f427b90	var j
0x5b1f0f427c30	var k
0x5b1f0f428000	var t0
0x5b1f0f4282f0	var t1
0x5b1f0f428540	var t2
0x5b1f0f428620	var t3
0x5b1f0f4287a0	var t4
0x5b1f0f4288d0	var t5
0x5b1f0f4289b0	var t6
0x5b1f0f428ae0	var t7
0x5b1f0f428d10	var t8
0x5b1f0f428df0	var t9
0x5b1f0f428f70	var t10
0x5b1f0f4290a0	var t11
0x5b1f0f429180	var t12
0x5b1f0f4292b0	var t13
0x5b1f0f4294f0	var t14
0x5b1f0f4298d0	var t15
0x5b1f0f427c90	input a
0x5b1f0f427cf0	input b
0x5b1f0f427d50	input c
0x5b1f0f427e60	j = 5
0x5b1f0f428580	t2 = b * c
0x5b1f0f428660	t3 = a + t2
0x5b1f0f4287e0	t4 = a + c
0x5b1f0f428910	t5 = t4 / b
0x5b1f0f4289f0	t6 = t3 - t5
0x5b1f0f428b20	t7 = 9 + t6
0x5b1f0f428b60	d = t7
0x5b1f0f428d50	t8 = t2
0x5b1f0f428e30	t9 = t3
0x5b1f0f428fb0	t10 = c - a
0x5b1f0f4290e0	t11 = t10 / b
0x5b1f0f4291c0	t12 = t9 - t11
0x5b1f0f4292f0	t13 = 9 + t12
0x5b1f0f429330	e = t13
0x5b1f0f429ab0	label L4
0x5b1f0f428040	t0 = (j > 0)
0x5b1f0f429bf0	ifz t0 goto L5
0x5b1f0f4280a0	output j
0x5b1f0f4281b0	i = 9
0x5b1f0f429630	label L1
0x5b1f0f428330	t1 = (i > 0)
0x5b1f0f429770	ifz t1 goto L2
0x5b1f0f428390	output i
0x5b1f0f429530	t14 = i - 1
0x5b1f0f429570	i = t14
0x5b1f0f429670	goto L1
0x5b1f0f429730	label L2
0x5b1f0f429910	t15 = j - 1
0x5b1f0f429950	j = t15
0x5b1f0f4299f0	output L3
0x5b1f0f429af0	goto L4
0x5b1f0f429bb0	label L5
0x5b1f0f429c90	output L6
0x5b1f0f429cf0	output d
0x5b1f0f429d50	output L3
0x5b1f0f429db0	output e
0x5b1f0f429e10	output L6
0x5b1f0f429f30	end

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
