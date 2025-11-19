	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var a

	# a = 10
	LOD R5,10

	# goto L2
	STO (R2+8),R5
	JMP L2

	# label L2
L2:

	# output a
	LOD R5,(R2+8)
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
