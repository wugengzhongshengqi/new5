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

	# var d

	# var e

	# var x

	# var y

	# var z

	# var i

	# input a
	LOD R5,(R2+8)
	ITI
	LOD R5,R15

	# input b
	LOD R6,(R2+12)
	ITI
	LOD R6,R15

	# input x
	LOD R7,(R2+28)
	ITI
	LOD R7,R15

	# input y
	LOD R8,(R2+32)
	ITI
	LOD R8,R15

	# var t0

	# t0 = a + b
	STO (R2+8),R5
	STO (R2+12),R6
	ADD R5,R6

	# c = t0
	STO (R2+44),R5

	# output c
	STO (R2+16),R5
	LOD R15,R5
	OTI

	# i = 0
	LOD R9,0

	# label L2
	STO (R2+28),R7
	STO (R2+32),R8
	STO (R2+40),R9
L2:

	# var t1

	# t1 = (i < 5)
	LOD R5,(R2+40)
	LOD R6,5
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JLZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t1 goto L3
	STO (R2+48),R5
	TST R5
	JEZ L3

	# var t2

	# t2 = a + b
	LOD R7,(R2+8)
	LOD R8,(R2+12)
	ADD R7,R8

	# d = t2
	STO (R2+52),R7

	# var t3

	# t3 = x * y
	LOD R9,(R2+28)
	LOD R10,(R2+32)
	MUL R9,R10

	# z = t3
	STO (R2+56),R9

	# output d
	STO (R2+20),R7
	LOD R15,R7
	OTI

	# output z
	STO (R2+36),R9
	LOD R15,R9
	OTI

	# var t4

	# t4 = (i > 2)
	LOD R11,(R2+40)
	LOD R12,2
	SUB R11,R12
	TST R11
	LOD R3,R1+40
	JGZ R3
	LOD R11,0
	LOD R3,R1+24
	JMP R3
	LOD R11,1

	# ifz t4 goto L1
	STO (R2+60),R11
	TST R11
	JEZ L1

	# var t5

	# e = t3
	LOD R13,(R2+56)

	# output e
	STO (R2+24),R13
	LOD R15,R13
	OTI

	# label L1
L1:

	# var t6

	# t6 = i + 1
	LOD R5,(R2+40)
	LOD R6,1
	ADD R5,R6

	# i = t6
	STO (R2+68),R5

	# goto L2
	STO (R2+40),R5
	JMP L2

	# label L3
L3:

	# var t7

	# t7 = a + b
	LOD R5,(R2+8)
	LOD R6,(R2+12)
	ADD R5,R6

	# e = t7
	STO (R2+72),R5

	# output e
	STO (R2+24),R5
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
