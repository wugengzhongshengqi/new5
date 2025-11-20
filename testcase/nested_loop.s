	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var i

	# var j

	# var k

	# var t0

	# var t1

	# var t2

	# var t3

	# var t4

	# var t5

	# k = 0
	LOD R5,0

	# label L4
	STO (R2+16),R5
L4:

	# t0 = (k < 10)
	LOD R5,(R2+16)
	LOD R6,10
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JLZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t0 goto L5
	STO (R2+20),R5
	TST R5
	JEZ L5

	# i = 0
	LOD R7,0

	# label L2
	STO (R2+8),R7
L2:

	# t1 = (i < 10)
	LOD R5,(R2+8)
	LOD R6,10
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JLZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t1 goto L3
	STO (R2+24),R5
	TST R5
	JEZ L3

	# t2 = i * 2
	LOD R7,(R2+8)
	LOD R8,2
	MUL R7,R8

	# t3 = t2 + 9
	STO (R2+28),R7
	LOD R9,9
	ADD R7,R9

	# j = t3
	STO (R2+32),R7

	# output j
	STO (R2+12),R7
	LOD R15,R7
	OTI

	# output L1
	LOD R10,L1
	LOD R15,R10
	OTS

	# t4 = i + 1
	LOD R11,(R2+8)
	LOD R12,1
	ADD R11,R12

	# i = t4
	STO (R2+36),R11

	# goto L2
	STO (R2+8),R11
	JMP L2

	# label L3
L3:

	# t5 = k + 1
	LOD R5,(R2+16)
	LOD R6,1
	ADD R5,R6

	# k = t5
	STO (R2+40),R5

	# goto L4
	STO (R2+16),R5
	JMP L4

	# label L5
L5:

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

	# tail
EXIT:
	END
L1:
	DBS 10,0
STATIC:
	DBN 0,0
STACK:
