
# Original TAC

# tac list

0x5aac2a12cbc0	label main
0x5aac2a12cc00	begin
0x5aac2a12b7d0	var i
0x5aac2a12b870	var j
0x5aac2a12b910	var k
0x5aac2a12ba20	k = 0
0x5aac2a12c9e0	label L4
0x5aac2a12bbc0	var t0
0x5aac2a12bc00	t0 = (k < 10)
0x5aac2a12cb20	ifz t0 goto L5
0x5aac2a12bcb0	i = 0
0x5aac2a12c600	label L2
0x5aac2a12bdf0	var t1
0x5aac2a12be30	t1 = (i < 10)
0x5aac2a12c740	ifz t1 goto L3
0x5aac2a12bff0	var t2
0x5aac2a12c030	t2 = 2 * i
0x5aac2a12c180	var t3
0x5aac2a12c1c0	t3 = t2 + 9
0x5aac2a12c200	j = t3
0x5aac2a12c260	output j
0x5aac2a12c300	output L1
0x5aac2a12c4c0	var t4
0x5aac2a12c500	t4 = i + 1
0x5aac2a12c540	i = t4
0x5aac2a12c640	goto L2
0x5aac2a12c700	label L3
0x5aac2a12c8a0	var t5
0x5aac2a12c8e0	t5 = k + 1
0x5aac2a12c920	k = t5
0x5aac2a12ca20	goto L4
0x5aac2a12cae0	label L5
0x5aac2a12cc40	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 1 iterations */

# Optimized TAC

# tac list

0x5aac2a12cbc0	label main
0x5aac2a12cc00	begin
0x5aac2a12b7d0	var i
0x5aac2a12b870	var j
0x5aac2a12b910	var k
0x5aac2a12bbc0	var t0
0x5aac2a12bdf0	var t1
0x5aac2a12bff0	var t2
0x5aac2a12c180	var t3
0x5aac2a12c4c0	var t4
0x5aac2a12c8a0	var t5
0x5aac2a12ba20	k = 0
0x5aac2a12c9e0	label L4
0x5aac2a12bc00	t0 = (k < 10)
0x5aac2a12cb20	ifz t0 goto L5
0x5aac2a12bcb0	i = 0
0x5aac2a12c600	label L2
0x5aac2a12be30	t1 = (i < 10)
0x5aac2a12c740	ifz t1 goto L3
0x5aac2a12c030	t2 = i * 2
0x5aac2a12c1c0	t3 = t2 + 9
0x5aac2a12c200	j = t3
0x5aac2a12c260	output j
0x5aac2a12c300	output L1
0x5aac2a12c500	t4 = i + 1
0x5aac2a12c540	i = t4
0x5aac2a12c640	goto L2
0x5aac2a12c700	label L3
0x5aac2a12c8e0	t5 = k + 1
0x5aac2a12c920	k = t5
0x5aac2a12ca20	goto L4
0x5aac2a12cae0	label L5
0x5aac2a12cc40	end

/* ========== Control Flow Graphs ========== */

/* CFG for function main */
digraph CFG_main {
    node [shape=box, fontname="Courier", fontsize=10];
    edge [fontname="Courier"];

    bb0 [label="BB0
─────────────────
var i
var j
var k
var t0
var t1
var t2
var t3
var t4
var t5
k = 0
"];
    bb1 [label="BB1 [L4]
─────────────────
L4:
t0 = (k < 10)
ifz t0 goto L5
"];
    bb2 [label="BB2
─────────────────
i = 0
"];
    bb3 [label="BB3 [L2]
─────────────────
L2:
t1 = (i < 10)
ifz t1 goto L3
"];
    bb4 [label="BB4
─────────────────
t2 = i * 2
t3 = t2 + 9
j = t3
output j
output L1
t4 = i + 1
i = t4
goto L2
"];
    bb5 [label="BB5 [L3]
─────────────────
L3:
t5 = k + 1
k = t5
goto L4
"];
    bb6 [label="BB6 [L5]
─────────────────
L5:
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
