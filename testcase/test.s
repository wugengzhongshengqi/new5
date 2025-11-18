	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var x

	# var y

	# var z

	# var c

	# var d

	# var a

	# var b

	# var t0

	# t0 = 5
	LOD R5,5

	# x = t0
	STO (R2+36),R5

	# var t1

	# t1 = x
	STO (R2+8),R5

	# y = t1
	STO (R2+40),R5

	# var t2

	# t2 = y
	STO (R2+12),R5

	# z = t2
	STO (R2+44),R5

	# c = 10
	LOD R6,10

	# d = c
	STO (R2+20),R6

	# var t3

	# t3 = 5
	LOD R7,5

	# a = t3
	STO (R2+48),R7

	# var t4

	# t4 = 0
	LOD R8,0

	# b = t4
	STO (R2+52),R8

	# output z
	STO (R2+16),R5
	LOD R15,R5
	OTI

	# output d
	STO (R2+24),R6
	LOD R15,R6
	OTI

	# output a
	STO (R2+28),R7
	LOD R15,R7
	OTI

	# output b
	STO (R2+32),R8
	LOD R15,R8
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
