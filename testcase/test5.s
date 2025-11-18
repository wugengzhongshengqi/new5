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

	# a = 10
	LOD R5,10

	# b = 20
	LOD R6,20

	# var t0

	# t0 = a + b
	STO (R2+8),R5
	STO (R2+12),R6
	ADD R5,R6

	# c = t0
	STO (R2+28),R5

	# var t1

	# t1 = t0
	LOD R7,(R2+28)

	# d = t1
	STO (R2+32),R7

	# var t2

	# t2 = t0
	LOD R8,(R2+28)

	# e = t2
	STO (R2+36),R8

	# return e
	STO (R2+16),R5
	STO (R2+20),R7
	STO (R2+24),R8
	LOD R4,(R2+24)
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

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
