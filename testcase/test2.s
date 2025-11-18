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

	# var a

	# var b

	# var c

	# var d

	# x = 100
	LOD R5,100

	# var t0

	# t0 = x
	STO (R2+8),R5

	# y = t0
	STO (R2+36),R5

	# var t1

	# t1 = x
	LOD R6,(R2+8)

	# z = t1
	STO (R2+40),R6

	# var t2

	# t2 = x
	LOD R7,(R2+8)

	# a = t2
	STO (R2+44),R7

	# var t3

	# t3 = x
	LOD R8,(R2+8)

	# b = t3
	STO (R2+48),R8

	# var t4

	# t4 = x
	LOD R9,(R2+8)

	# c = t4
	STO (R2+52),R9

	# var t5

	# t5 = x
	LOD R10,(R2+8)

	# d = t5
	STO (R2+56),R10

	# end
	STO (R2+12),R5
	STO (R2+16),R6
	STO (R2+20),R7
	STO (R2+24),R8
	STO (R2+28),R9
	STO (R2+32),R10
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

	# tail
EXIT:
	END
STATIC:
	DBN 0,0
STACK:
