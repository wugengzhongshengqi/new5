	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var i

	# var n

	# var x

	# var y

	# var result

	# input n
	LOD R5,(R2+12)
	ITI
	LOD R5,R15

	# x = 5
	LOD R6,5

	# y = 10
	LOD R7,10

	# i = 0
	LOD R8,0

	# label L1
	STO (R2+12),R5
	STO (R2+16),R6
	STO (R2+20),R7
	STO (R2+8),R8
L1:

	# var t0

	# t0 = (i < n)
	LOD R5,(R2+8)
	LOD R6,(R2+12)
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JLZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t0 goto L2
	STO (R2+28),R5
	TST R5
	JEZ L2

	# var t1

	# t1 = x + y
	LOD R7,(R2+16)
	LOD R8,(R2+20)
	ADD R7,R8

	# result = t1
	STO (R2+32),R7

	# output result
	STO (R2+24),R7
	LOD R15,R7
	OTI

	# var t2

	# t2 = i + 1
	LOD R9,(R2+8)
	LOD R10,1
	ADD R9,R10

	# i = t2
	STO (R2+36),R9

	# goto L1
	STO (R2+8),R9
	JMP L1

	# label L2
L2:

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

	# tail
EXIT:
	END
STATIC:
	DBN 0,0
STACK:
