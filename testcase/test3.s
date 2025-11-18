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

	# a = 5
	LOD R5,5

	# var t0

	# t0 = 0
	LOD R6,0

	# b = t0
	STO (R2+24),R6

	# var t1

	# t1 = 0
	LOD R7,0

	# c = t1
	STO (R2+28),R7

	# var t2

	# t2 = 0
	LOD R8,0

	# d = t2
	STO (R2+32),R8

	# return d
	STO (R2+8),R5
	STO (R2+12),R6
	STO (R2+16),R7
	STO (R2+20),R8
	LOD R4,(R2+20)
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
