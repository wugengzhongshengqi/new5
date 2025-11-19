
# Original TAC

# tac list

0x5e95ce0afeb0	label main
0x5e95ce0afef0	begin
0x5e95ce0ad7d0	var a
0x5e95ce0ad870	var b
0x5e95ce0ad910	var c
0x5e95ce0ad9b0	var d
0x5e95ce0ada50	var e
0x5e95ce0adaf0	var i
0x5e95ce0adb90	var j
0x5e95ce0adc30	var k
0x5e95ce0adc90	input a
0x5e95ce0adcf0	input b
0x5e95ce0add50	input c
0x5e95ce0ade60	j = 5
0x5e95ce0afab0	label L4
0x5e95ce0ae000	var t0
0x5e95ce0ae040	t0 = (j > 0)
0x5e95ce0afbf0	ifz t0 goto L5
0x5e95ce0ae0a0	output j
0x5e95ce0ae1b0	i = 9
0x5e95ce0af630	label L1
0x5e95ce0ae2f0	var t1
0x5e95ce0ae330	t1 = (i > 0)
0x5e95ce0af770	ifz t1 goto L2
0x5e95ce0ae390	output i
0x5e95ce0ae540	var t2
0x5e95ce0ae580	t2 = b * c
0x5e95ce0ae620	var t3
0x5e95ce0ae660	t3 = a + t2
0x5e95ce0ae7a0	var t4
0x5e95ce0ae7e0	t4 = a + c
0x5e95ce0ae8d0	var t5
0x5e95ce0ae910	t5 = t4 / b
0x5e95ce0ae9b0	var t6
0x5e95ce0ae9f0	t6 = t3 - t5
0x5e95ce0aeae0	var t7
0x5e95ce0aeb20	t7 = t6 + 9
0x5e95ce0aeb60	d = t7
0x5e95ce0aed10	var t8
0x5e95ce0aed50	t8 = b * c
0x5e95ce0aedf0	var t9
0x5e95ce0aee30	t9 = a + t8
0x5e95ce0aef70	var t10
0x5e95ce0aefb0	t10 = c - a
0x5e95ce0af0a0	var t11
0x5e95ce0af0e0	t11 = t10 / b
0x5e95ce0af180	var t12
0x5e95ce0af1c0	t12 = t9 - t11
0x5e95ce0af2b0	var t13
0x5e95ce0af2f0	t13 = t12 + 9
0x5e95ce0af330	e = t13
0x5e95ce0af4f0	var t14
0x5e95ce0af530	t14 = i - 1
0x5e95ce0af570	i = t14
0x5e95ce0af670	goto L1
0x5e95ce0af730	label L2
0x5e95ce0af8d0	var t15
0x5e95ce0af910	t15 = j - 1
0x5e95ce0af950	j = t15
0x5e95ce0af9f0	output L3
0x5e95ce0afaf0	goto L4
0x5e95ce0afbb0	label L5
0x5e95ce0afc90	output L6
0x5e95ce0afcf0	output d
0x5e95ce0afd50	output L3
0x5e95ce0afdb0	output e
0x5e95ce0afe10	output L6
0x5e95ce0aff30	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 2 iterations */

# Optimized TAC

# tac list

0x5e95ce0afeb0	label main
0x5e95ce0afef0	begin
0x5e95ce0ad7d0	var a
0x5e95ce0ad870	var b
0x5e95ce0ad910	var c
0x5e95ce0ad9b0	var d
0x5e95ce0ada50	var e
0x5e95ce0adaf0	var i
0x5e95ce0adb90	var j
0x5e95ce0adc30	var k
0x5e95ce0adc90	input a
0x5e95ce0adcf0	input b
0x5e95ce0add50	input c
0x5e95ce0ade60	j = 5
0x5e95ce0afab0	label L4
0x5e95ce0ae000	var t0
0x5e95ce0ae040	t0 = (j > 0)
0x5e95ce0afbf0	ifz t0 goto L5
0x5e95ce0ae0a0	output j
0x5e95ce0ae1b0	i = 9
0x5e95ce0af630	label L1
0x5e95ce0ae2f0	var t1
0x5e95ce0ae330	t1 = (i > 0)
0x5e95ce0af770	ifz t1 goto L2
0x5e95ce0ae390	output i
0x5e95ce0ae540	var t2
0x5e95ce0ae580	t2 = b * c
0x5e95ce0ae620	var t3
0x5e95ce0ae660	t3 = a + t2
0x5e95ce0ae7a0	var t4
0x5e95ce0ae7e0	t4 = a + c
0x5e95ce0ae8d0	var t5
0x5e95ce0ae910	t5 = t4 / b
0x5e95ce0ae9b0	var t6
0x5e95ce0ae9f0	t6 = t3 - t5
0x5e95ce0aeae0	var t7
0x5e95ce0aeb20	t7 = 9 + t6
0x5e95ce0aeb60	d = t7
0x5e95ce0aed10	var t8
0x5e95ce0aed50	t8 = t2
0x5e95ce0aedf0	var t9
0x5e95ce0aee30	t9 = a + t8
0x5e95ce0aef70	var t10
0x5e95ce0aefb0	t10 = c - a
0x5e95ce0af0a0	var t11
0x5e95ce0af0e0	t11 = t10 / b
0x5e95ce0af180	var t12
0x5e95ce0af1c0	t12 = t9 - t11
0x5e95ce0af2b0	var t13
0x5e95ce0af2f0	t13 = 9 + t12
0x5e95ce0af330	e = t13
0x5e95ce0af4f0	var t14
0x5e95ce0af530	t14 = i - 1
0x5e95ce0af570	i = t14
0x5e95ce0af670	goto L1
0x5e95ce0af730	label L2
0x5e95ce0af8d0	var t15
0x5e95ce0af910	t15 = j - 1
0x5e95ce0af950	j = t15
0x5e95ce0af9f0	output L3
0x5e95ce0afaf0	goto L4
0x5e95ce0afbb0	label L5
0x5e95ce0afc90	output L6
0x5e95ce0afcf0	output d
0x5e95ce0afd50	output L3
0x5e95ce0afdb0	output e
0x5e95ce0afe10	output L6
0x5e95ce0aff30	end

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
input a
input b
input c
j = 5
"];
    bb1 [label="BB1 [L4]
─────────────────
L4:
var t0
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
var t1
t1 = (i > 0)
ifz t1 goto L2
"];
    bb4 [label="BB4
─────────────────
output i
var t2
t2 = b * c
var t3
t3 = a + t2
var t4
t4 = a + c
var t5
t5 = t4 / b
var t6
t6 = t3 - t5
var t7
t7 = 9 + t6
d = t7
var t8
t8 = t2
var t9
t9 = a + t8
var t10
t10 = c - a
var t11
t11 = t10 / b
var t12
t12 = t9 - t11
var t13
t13 = 9 + t12
e = t13
var t14
t14 = i - 1
i = t14
goto L1
"];
    bb5 [label="BB5 [L2]
─────────────────
L2:
var t15
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
