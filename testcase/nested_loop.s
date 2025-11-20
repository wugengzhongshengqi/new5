	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var i

	# var j

	# var k

	# var t0

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t1

	# var t2

	# var t3

	# var t4

	# var t5

	# k = 0
	LOD R5,0

	# label L4
	STO (R2+16),R5
L4:

	# t0 = (k < 10)
	LOD R5,(R2+16)
	LOD R6,10
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JLZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t0 goto L5
	STO (R2+20),R5
	TST R5
	JEZ L5

	# label L2
L2:

	# j = 9
	LOD R5,9

	# output j
	STO (R2+12),R5
	LOD R15,R5
	OTI

	# output L1
	LOD R6,L1
	LOD R15,R6
	OTS

	# j = 11
	LOD R7,11

	# output j
	STO (R2+12),R7
	LOD R15,R7
	OTI

	# output L1
	LOD R15,R6
	OTS

	# j = 13
	LOD R5,13

	# output j
	STO (R2+12),R5
	LOD R15,R5
	OTI

	# output L1
	LOD R15,R6
	OTS

	# j = 15
	LOD R7,15

	# output j
	STO (R2+12),R7
	LOD R15,R7
	OTI

	# output L1
	LOD R15,R6
	OTS

	# j = 17
	LOD R5,17

	# output j
	STO (R2+12),R5
	LOD R15,R5
	OTI

	# output L1
	LOD R15,R6
	OTS

	# j = 19
	LOD R7,19

	# output j
	STO (R2+12),R7
	LOD R15,R7
	OTI

	# output L1
	LOD R15,R6
	OTS

	# j = 21
	LOD R5,21

	# output j
	STO (R2+12),R5
	LOD R15,R5
	OTI

	# output L1
	LOD R15,R6
	OTS

	# j = 23
	LOD R7,23

	# output j
	STO (R2+12),R7
	LOD R15,R7
	OTI

	# output L1
	LOD R15,R6
	OTS

	# j = 25
	LOD R5,25

	# output j
	STO (R2+12),R5
	LOD R15,R5
	OTI

	# output L1
	LOD R15,R6
	OTS

	# j = 27
	LOD R7,27

	# output j
	STO (R2+12),R7
	LOD R15,R7
	OTI

	# output L1
	LOD R15,R6
	OTS

	# label L3
L3:

	# t5 = k + 1
	LOD R5,(R2+16)
	LOD R6,1
	ADD R5,R6

	# k = t5
	STO (R2+184),R5

	# goto L4
	STO (R2+16),R5
	JMP L4

	# label L5
L5:

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

	# tail
EXIT:
	END
L1:
	DBS 10,0
STATIC:
	DBN 0,0
STACK:
