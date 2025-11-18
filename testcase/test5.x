
# Original TAC

# tac list

0x5bec54cf9340	label main
0x5bec54cf9380	begin
0x5bec54cf87d0	var a
0x5bec54cf8870	var b
0x5bec54cf8910	var c
0x5bec54cf89b0	var d
0x5bec54cf8a50	var e
0x5bec54cf8b60	a = 10
0x5bec54cf8c70	b = 20
0x5bec54cf8dd0	var t0
0x5bec54cf8e10	t0 = a + b
0x5bec54cf8e50	c = t0
0x5bec54cf8fb0	var t1
0x5bec54cf8ff0	t1 = a + b
0x5bec54cf9030	d = t1
0x5bec54cf9190	var t2
0x5bec54cf91d0	t2 = a + b
0x5bec54cf9210	e = t2
0x5bec54cf92a0	return e
0x5bec54cf93c0	end

/* ========== Local Optimizations ========== */

/* Optimizing function main */
/* main: 2 iterations, optimized */

# Optimized TAC

# tac list

0x5bec54cf9340	label main
0x5bec54cf9380	begin
0x5bec54cf87d0	var a
0x5bec54cf8870	var b
0x5bec54cf8910	var c
0x5bec54cf89b0	var d
0x5bec54cf8a50	var e
0x5bec54cf8b60	a = 10
0x5bec54cf8c70	b = 20
0x5bec54cf8dd0	var t0
0x5bec54cf8e10	t0 = a + b
0x5bec54cf8e50	c = t0
0x5bec54cf8fb0	var t1
0x5bec54cf8ff0	t1 = t0
0x5bec54cf9030	d = t1
0x5bec54cf9190	var t2
0x5bec54cf91d0	t2 = t0
0x5bec54cf9210	e = t2
0x5bec54cf92a0	return e
0x5bec54cf93c0	end

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
a = 10
b = 20
var t0
t0 = a + b
c = t0
var t1
t1 = t0
d = t1
var t2
t2 = t0
e = t2
return e
"];

}
