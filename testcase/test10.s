	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var a

	# var b

	# var c

	# var i

	# var n

	# var l

	# var u

	# var r

	# var t0

	# var t1

	# var t2

	# var t3

	# var t4

	# var t5

	# var t6

	# r = 0
	LOD R5,0

	# u = 1000
	LOD R6,1000

	# i = 0
	LOD R7,0

	# t2 = 30 * 2
	LOD R8,30
	LOD R9,2
	MUL R8,R9

	# l = 60
	LOD R10,60

	# label L1
	STO (R2+36),R5
	STO (R2+32),R6
	STO (R2+20),R7
	STO (R2+48),R8
	STO (R2+28),R10
L1:

	# t1 = (i < 5)
	LOD R5,(R2+20)
	LOD R6,5
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JLZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t1 goto L2
	STO (R2+44),R5
	TST R5
	JEZ L2

	# t3 = u + 1
	LOD R7,(R2+32)
	LOD R8,1
	ADD R7,R8

	# u = t3
	STO (R2+52),R7

	# t4 = i + r
	LOD R9,(R2+20)
	LOD R10,(R2+36)
	ADD R9,R10

	# t5 = t4 + 60
	STO (R2+56),R9
	LOD R11,60
	ADD R9,R11

	# r = t5
	STO (R2+60),R9

	# t6 = i + 1
	LOD R10,(R2+20)
	ADD R10,R8

	# i = t6
	STO (R2+64),R10

	# goto L1
	STO (R2+32),R7
	STO (R2+36),R9
	STO (R2+20),R10
	JMP L1

	# label L2
L2:

	# output l
	LOD R5,(R2+28)
	LOD R15,R5
	OTI

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
