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

	# var i

	# var j

	# var k

	# var t0

	# var t1

	# var t2

	# var t3

	# var t4

	# var t5

	# var t6

	# var t7

	# var t8

	# var t9

	# var t10

	# var t11

	# var t12

	# var t13

	# var t14

	# var t15

	# input a
	LOD R5,(R2+8)
	ITI
	LOD R5,R15

	# input b
	LOD R6,(R2+12)
	ITI
	LOD R6,R15

	# input c
	LOD R7,(R2+16)
	ITI
	LOD R7,R15

	# j = 5
	LOD R8,5

	# t2 = b * c
	STO (R2+12),R6
	STO (R2+16),R7
	MUL R6,R7

	# t3 = a + t2
	STO (R2+8),R5
	STO (R2+48),R6
	ADD R5,R6

	# t4 = a + c
	LOD R9,(R2+8)
	ADD R9,R7

	# t5 = t4 / b
	STO (R2+56),R9
	LOD R10,(R2+12)
	DIV R9,R10

	# t6 = t3 - t5
	STO (R2+52),R5
	STO (R2+60),R9
	SUB R5,R9

	# t7 = 9 + t6
	LOD R11,9
	STO (R2+64),R5
	ADD R11,R5

	# d = t7
	STO (R2+68),R11

	# t8 = t2

	# t9 = t3
	LOD R12,(R2+52)

	# t10 = c - a
	LOD R13,(R2+8)
	SUB R7,R13

	# t11 = t10 / b
	STO (R2+80),R7
	DIV R7,R10

	# t12 = t9 - t11
	STO (R2+76),R12
	STO (R2+84),R7
	SUB R12,R7

	# t13 = 9 + t12
	LOD R14,9
	STO (R2+88),R12
	ADD R14,R12

	# e = t13
	STO (R2+92),R14

	# label L4
	STO (R2+72),R6
	STO (R2+32),R8
	STO (R2+20),R11
	STO (R2+24),R14
L4:

	# t0 = (j > 0)
	LOD R5,(R2+32)
	LOD R6,0
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JGZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t0 goto L5
	STO (R2+40),R5
	TST R5
	JEZ L5

	# output j
	LOD R7,(R2+32)
	LOD R15,R7
	OTI

	# i = 9
	LOD R8,9

	# label L1
	STO (R2+28),R8
L1:

	# t1 = (i > 0)
	LOD R5,(R2+28)
	LOD R6,0
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JGZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t1 goto L2
	STO (R2+44),R5
	TST R5
	JEZ L2

	# output i
	LOD R7,(R2+28)
	LOD R15,R7
	OTI

	# t14 = i - 1
	LOD R8,1
	SUB R7,R8

	# i = t14
	STO (R2+96),R7

	# goto L1
	STO (R2+28),R7
	JMP L1

	# label L2
L2:

	# t15 = j - 1
	LOD R5,(R2+32)
	LOD R6,1
	SUB R5,R6

	# j = t15
	STO (R2+100),R5

	# output L3
	LOD R7,L3
	LOD R15,R7
	OTS

	# goto L4
	STO (R2+32),R5
	JMP L4

	# label L5
L5:

	# output L6
	LOD R5,L6
	LOD R15,R5
	OTS

	# output d
	LOD R6,(R2+20)
	LOD R15,R6
	OTI

	# output L3
	LOD R7,L3
	LOD R15,R7
	OTS

	# output e
	LOD R8,(R2+24)
	LOD R15,R8
	OTI

	# output L6
	LOD R15,R5
	OTS

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

	# tail
EXIT:
	END
L6:
	DBS 10,0
L3:
	DBS 32,0
STATIC:
	DBN 0,0
STACK:
