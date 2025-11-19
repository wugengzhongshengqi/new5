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

	# a = 3
	LOD R5,3

	# var t1

	# b = 9
	LOD R6,9

	# var t2

	# c = 9
	LOD R7,9

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
