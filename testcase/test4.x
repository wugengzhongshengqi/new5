
# tac list

0x560dda68d680	label main
0x560dda68d6c0	begin
0x560dda68c7d0	var i
0x560dda68c870	var n
0x560dda68c910	var x
0x560dda68c9b0	var y
0x560dda68ca50	var result
0x560dda68cab0	input n
0x560dda68cbc0	x = 5
0x560dda68ccd0	y = 10
0x560dda68cde0	i = 0
0x560dda68d4a0	label L1
0x560dda68cf20	var t0
0x560dda68cf60	t0 = (i < n)
0x560dda68d5e0	ifz t0 goto L2
0x560dda68d0c0	var t1
0x560dda68d100	t1 = x + y
0x560dda68d140	result = t1
0x560dda68d1a0	output result
0x560dda68d360	var t2
0x560dda68d3a0	t2 = i + 1
0x560dda68d3e0	i = t2
0x560dda68d4e0	goto L1
0x560dda68d5a0	label L2
0x560dda68d700	end
