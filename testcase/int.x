
# tac list

0x6479e4625390	label main
0x6479e46253d0	begin
0x6479e46247d0	var a
0x6479e4624870	var b
0x6479e4624910	var c
0x6479e46249b0	var d
0x6479e4624a10	input a
0x6479e4624bd0	var t0
0x6479e4624c10	t0 = a + 10
0x6479e4624c50	b = t0
0x6479e4624e10	var t1
0x6479e4624e50	t1 = b - 20
0x6479e4624e90	c = t1
0x6479e4625050	var t2
0x6479e4625090	t2 = c * 30
0x6479e46250d0	d = t2
0x6479e4625130	output a
0x6479e4625190	output b
0x6479e46251f0	output c
0x6479e4625250	output d
0x6479e46252f0	output L1
0x6479e4625410	end

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
input a
var t0
t0 = a + 10
b = t0
var t1
t1 = b - 20
c = t1
var t2
t2 = c * 30
d = t2
output a
output b
output c
output d
output L1
"];

}
