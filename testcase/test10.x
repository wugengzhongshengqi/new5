
# Original TAC

# tac list

0x6326e60482b0	label main
0x6326e60482f0	begin
0x6326e60467d0	var a
0x6326e6046870	var b
0x6326e6046910	var c
0x6326e60469b0	var i
0x6326e6046a50	var n
0x6326e6046af0	var l
0x6326e6046b90	var u
0x6326e6046c30	var r
0x6326e6046d40	a = 10
0x6326e6046e50	b = 20
0x6326e6046f60	n = 5
0x6326e6047070	r = 0
0x6326e60471d0	var t0
0x6326e6047210	t0 = a + b
0x6326e6047250	c = t0
0x6326e6047360	u = 1000
0x6326e6047410	i = 0
0x6326e6048070	label L1
0x6326e6047550	var t1
0x6326e6047590	t1 = (i < n)
0x6326e60481b0	ifz t1 goto L2
0x6326e6047750	var t2
0x6326e6047790	t2 = c * 2
0x6326e60477d0	l = t2
0x6326e6047990	var t3
0x6326e60479d0	t3 = u + 1
0x6326e6047a10	u = t3
0x6326e6047b70	var t4
0x6326e6047bb0	t4 = r + i
0x6326e6047bf0	r = t4
0x6326e6047d50	var t5
0x6326e6047d90	t5 = r + l
0x6326e6047dd0	r = t5
0x6326e6047f30	var t6
0x6326e6047f70	t6 = i + 1
0x6326e6047fb0	i = t6
0x6326e60480b0	goto L1
0x6326e6048170	label L2
0x6326e6048210	output l
0x6326e6048330	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 2 iterations */

# Optimized TAC

# tac list

0x6326e60482b0	label main
0x6326e60482f0	begin
0x6326e60467d0	var a
0x6326e6046870	var b
0x6326e6046910	var c
0x6326e60469b0	var i
0x6326e6046a50	var n
0x6326e6046af0	var l
0x6326e6046b90	var u
0x6326e6046c30	var r
0x6326e60471d0	var t0
0x6326e6047550	var t1
0x6326e6047750	var t2
0x6326e6047990	var t3
0x6326e6047b70	var t4
0x6326e6047d50	var t5
0x6326e6047f30	var t6
0x6326e6047070	r = 0
0x6326e6047360	u = 1000
0x6326e6047410	i = 0
0x6326e6047790	t2 = 30 * 2
0x6326e60477d0	l = 60
0x6326e6048070	label L1
0x6326e6047590	t1 = (i < 5)
0x6326e60481b0	ifz t1 goto L2
0x6326e60479d0	t3 = u + 1
0x6326e6047a10	u = t3
0x6326e6047bb0	t4 = i + r
0x6326e6047d90	t5 = t4 + 60
0x6326e6047dd0	r = t5
0x6326e6047f70	t6 = i + 1
0x6326e6047fb0	i = t6
0x6326e60480b0	goto L1
0x6326e6048170	label L2
0x6326e6048210	output l
0x6326e6048330	end

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
var i
var n
var l
var u
var r
var t0
var t1
var t2
var t3
var t4
var t5
var t6
r = 0
u = 1000
i = 0
t2 = 30 * 2
l = 60
"];
    bb1 [label="BB1 [L1]
─────────────────
L1:
t1 = (i < 5)
ifz t1 goto L2
"];
    bb2 [label="BB2
─────────────────
t3 = u + 1
u = t3
t4 = i + r
t5 = t4 + 60
r = t5
t6 = i + 1
i = t6
goto L1
"];
    bb3 [label="BB3 [L2]
─────────────────
L2:
output l
"];

    bb0 -> bb1;
    bb1 -> bb2 [label="false", color="blue"];
    bb1 -> bb3 [label="true", color="red"];
    bb2 -> bb1;
}
