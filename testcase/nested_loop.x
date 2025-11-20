
# Original TAC

# tac list

0x5a70cb931bc0	label main
0x5a70cb931c00	begin
0x5a70cb9307d0	var i
0x5a70cb930870	var j
0x5a70cb930910	var k
0x5a70cb930a20	k = 0
0x5a70cb9319e0	label L4
0x5a70cb930bc0	var t0
0x5a70cb930c00	t0 = (k < 10)
0x5a70cb931b20	ifz t0 goto L5
0x5a70cb930cb0	i = 0
0x5a70cb931600	label L2
0x5a70cb930df0	var t1
0x5a70cb930e30	t1 = (i < 10)
0x5a70cb931740	ifz t1 goto L3
0x5a70cb930ff0	var t2
0x5a70cb931030	t2 = 2 * i
0x5a70cb931180	var t3
0x5a70cb9311c0	t3 = t2 + 9
0x5a70cb931200	j = t3
0x5a70cb931260	output j
0x5a70cb931300	output L1
0x5a70cb9314c0	var t4
0x5a70cb931500	t4 = i + 1
0x5a70cb931540	i = t4
0x5a70cb931640	goto L2
0x5a70cb931700	label L3
0x5a70cb9318a0	var t5
0x5a70cb9318e0	t5 = k + 1
0x5a70cb931920	k = t5
0x5a70cb931a20	goto L4
0x5a70cb931ae0	label L5
0x5a70cb931c40	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Loop Unrolled */
/* Result: 4 iterations */

# Optimized TAC

# tac list

0x5a70cb931bc0	label main
0x5a70cb931c00	begin
0x5a70cb9307d0	var i
0x5a70cb930870	var j
0x5a70cb930910	var k
0x5a70cb930bc0	var t0
0x5a70cb9353b0	var t1
0x5a70cb9358a0	var t2
0x5a70cb935920	var t3
0x5a70cb935a60	var t4
0x5a70cb935b20	var t1
0x5a70cb935be0	var t2
0x5a70cb935c60	var t3
0x5a70cb935da0	var t4
0x5a70cb935e60	var t1
0x5a70cb935f20	var t2
0x5a70cb935fa0	var t3
0x5a70cb9360e0	var t4
0x5a70cb9361a0	var t1
0x5a70cb936260	var t2
0x5a70cb9362e0	var t3
0x5a70cb936420	var t4
0x5a70cb9364e0	var t1
0x5a70cb9365a0	var t2
0x5a70cb936620	var t3
0x5a70cb936760	var t4
0x5a70cb936820	var t1
0x5a70cb9368e0	var t2
0x5a70cb936960	var t3
0x5a70cb936aa0	var t4
0x5a70cb936b60	var t1
0x5a70cb936c20	var t2
0x5a70cb936ca0	var t3
0x5a70cb936de0	var t4
0x5a70cb936ea0	var t1
0x5a70cb936f60	var t2
0x5a70cb936fe0	var t3
0x5a70cb937120	var t4
0x5a70cb9371e0	var t1
0x5a70cb9372a0	var t2
0x5a70cb937320	var t3
0x5a70cb937460	var t4
0x5a70cb937520	var t1
0x5a70cb9375e0	var t2
0x5a70cb937660	var t3
0x5a70cb9377a0	var t4
0x5a70cb9318a0	var t5
0x5a70cb930a20	k = 0
0x5a70cb9319e0	label L4
0x5a70cb930c00	t0 = (k < 10)
0x5a70cb931b20	ifz t0 goto L5
0x5a70cb931600	label L2
0x5a70cb9359a0	j = 9
0x5a70cb9359e0	output j
0x5a70cb935a20	output L1
0x5a70cb935ce0	j = 11
0x5a70cb935d20	output j
0x5a70cb935d60	output L1
0x5a70cb936020	j = 13
0x5a70cb936060	output j
0x5a70cb9360a0	output L1
0x5a70cb936360	j = 15
0x5a70cb9363a0	output j
0x5a70cb9363e0	output L1
0x5a70cb9366a0	j = 17
0x5a70cb9366e0	output j
0x5a70cb936720	output L1
0x5a70cb9369e0	j = 19
0x5a70cb936a20	output j
0x5a70cb936a60	output L1
0x5a70cb936d20	j = 21
0x5a70cb936d60	output j
0x5a70cb936da0	output L1
0x5a70cb937060	j = 23
0x5a70cb9370a0	output j
0x5a70cb9370e0	output L1
0x5a70cb9373a0	j = 25
0x5a70cb9373e0	output j
0x5a70cb937420	output L1
0x5a70cb9376e0	j = 27
0x5a70cb937720	output j
0x5a70cb937760	output L1
0x5a70cb931700	label L3
0x5a70cb9318e0	t5 = k + 1
0x5a70cb931920	k = t5
0x5a70cb931a20	goto L4
0x5a70cb931ae0	label L5
0x5a70cb931c40	end

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
var t1
var t2
var t3
var t4
var t1
var t2
var t3
var t4
var t1
var t2
var t3
var t4
var t1
var t2
var t3
var t4
var t1
var t2
var t3
var t4
var t1
var t2
var t3
var t4
var t1
var t2
var t3
var t4
var t1
var t2
var t3
var t4
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
    bb2 [label="BB2 [L2]
─────────────────
L2:
j = 9
output j
output L1
j = 11
output j
output L1
j = 13
output j
output L1
j = 15
output j
output L1
j = 17
output j
output L1
j = 19
output j
output L1
j = 21
output j
output L1
j = 23
output j
output L1
j = 25
output j
output L1
j = 27
output j
output L1
"];
    bb3 [label="BB3 [L3]
─────────────────
L3:
t5 = k + 1
k = t5
goto L4
"];
    bb4 [label="BB4 [L5]
─────────────────
L5:
"];

    bb0 -> bb1;
    bb1 -> bb2 [label="false", color="blue"];
    bb1 -> bb4 [label="true", color="red"];
    bb2 -> bb3;
    bb3 -> bb1;
}
