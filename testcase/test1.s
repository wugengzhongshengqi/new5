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

	# var f

	# var g

	# var h

	# var t0

	# t0 = 5
	LOD R5,5

	# a = t0
	STO (R2+40),R5

	# var t1

	# t1 = 6
	LOD R6,6

	# b = t1
	STO (R2+44),R6

	# var t2

	# t2 = 42
	LOD R7,42

	# c = t2
	STO (R2+48),R7

	# var t3

	# t3 = 4
	LOD R8,4

	# d = t3
	STO (R2+52),R8

	# var t4

	# t4 = -10
	LOD R9,4294967286

	# e = t4
	STO (R2+56),R9

	# var t5

	# t5 = 1
	LOD R10,1

	# f = t5
	STO (R2+60),R10

	# var t6

	# t6 = 1
	LOD R11,1

	# g = t6
	STO (R2+64),R11

	# var t7

	# t7 = 0
	LOD R12,0

	# h = t7
	STO (R2+68),R12

	# output a
	STO (R2+8),R5
	LOD R15,R5
	OTI

	# output b
	STO (R2+12),R6
	LOD R15,R6
	OTI

	# output c
	STO (R2+16),R7
	LOD R15,R7
	OTI

	# output d
	STO (R2+20),R8
	LOD R15,R8
	OTI

	# output e
	STO (R2+24),R9
	LOD R15,R9
	OTI

	# output f
	STO (R2+28),R10
	LOD R15,R10
	OTI

	# output g
	STO (R2+32),R11
	LOD R15,R11
	OTI

	# output h
	STO (R2+36),R12
	LOD R15,R12
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
