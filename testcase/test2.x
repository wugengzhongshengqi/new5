
# Original TAC

# tac list

0x62b47b96d940	label main
0x62b47b96d980	begin
0x62b47b96c7d0	var x
0x62b47b96c870	var y
0x62b47b96c910	var z
0x62b47b96c9b0	var a
0x62b47b96ca50	var b
0x62b47b96caf0	var c
0x62b47b96cb90	var d
0x62b47b96cca0	x = 100
0x62b47b96ce60	var t0
0x62b47b96cea0	t0 = x + 0
0x62b47b96cee0	y = t0
0x62b47b96d040	var t1
0x62b47b96d080	t1 = 0 + x
0x62b47b96d0c0	z = t1
0x62b47b96d220	var t2
0x62b47b96d260	t2 = x - 0
0x62b47b96d2a0	a = t2
0x62b47b96d460	var t3
0x62b47b96d4a0	t3 = x * 1
0x62b47b96d4e0	b = t3
0x62b47b96d640	var t4
0x62b47b96d680	t4 = 1 * x
0x62b47b96d6c0	c = t4
0x62b47b96d820	var t5
0x62b47b96d860	t5 = x / 1
0x62b47b96d8a0	d = t5
0x62b47b96d9c0	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 15 iterations */

# Optimized TAC

# tac list

0x62b47b96d940	label main
0x62b47b96d980	begin
0x62b47b96d9c0	end

/* ========== Control Flow Graphs ========== */

/* CFG for function main */
digraph CFG_main {
    node [shape=box, fontname="Courier", fontsize=10];
    edge [fontname="Courier"];


}
