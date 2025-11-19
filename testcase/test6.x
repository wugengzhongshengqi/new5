
# Original TAC

# tac list

0x624793711530	label main
0x624793711570	begin
0x6247937107d0	var a
0x624793710870	var b
0x624793710910	var c
0x6247937109b0	var d
0x624793710bd0	var t0
0x624793710c10	t0 = 2 + 3
0x624793710c50	a = t0
0x624793710e10	var t1
0x624793710e50	t1 = a + 0
0x624793710e90	b = t1
0x624793710ff0	var t2
0x624793711030	t2 = a + 0
0x624793711070	c = t2
0x624793711290	var t3
0x6247937112d0	t3 = 5 * 1
0x624793711310	d = t3
0x624793711370	output a
0x6247937113d0	output b
0x624793711430	output c
0x624793711490	output d
0x6247937115b0	end

/* ========== Global Optimizations ========== */

/* Optimizing function main */
/* Result: 2 iterations */

# Optimized TAC

# tac list

0x624793711530	label main
0x624793711570	begin
0x6247937107d0	var a
0x624793710870	var b
0x624793710910	var c
0x6247937109b0	var d
0x624793710bd0	var t0
0x624793710c50	a = 5
0x624793710e10	var t1
0x624793710e90	b = 5
0x624793710ff0	var t2
0x624793711070	c = 5
0x624793711290	var t3
0x624793711310	d = 5
0x624793711370	output a
0x6247937113d0	output b
0x624793711430	output c
0x624793711490	output d
0x6247937115b0	end

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
var t0
a = 5
var t1
b = 5
var t2
c = 5
var t3
d = 5
output a
output b
output c
output d
"];

}
