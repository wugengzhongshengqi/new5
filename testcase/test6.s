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

	# var t0

	# a = 5
	LOD R5,5

	# var t1

	# b = 5
	LOD R6,5

	# var t2

	# c = 5
	LOD R7,5

	# var t3

	# d = 5
	LOD R8,5

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
