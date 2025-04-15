		### Test jal ###
		addi x1, zero, 200	# load x1 with non-zero
		jal x30, ROUTINE	# jump to a routine, will add 100
		addi x1, x1, 50		# should return here with x1 = 300
		addi x2, zero, 350	# setup expected answer
		add x2, x2, zero
		add x2, x2, zero
		bne x2, x1, FAIL
		### Now test JAL with + immediate ###
		addi x1, zero, 400
		jal x30, ROUTINE2	# will add 200
		addi x1, x1, 100	# should be skipped on return
		addi x1, x1, 50		# should be skipped on return
		addi x2, zero, 600	# setup expected answer
		bne x1, x2, FAIL
		### Now test JAL with - immediate ###
		addi x1, zero, 300
		j SKIP
		addi x1, x1, 75		# should be hit on return
                addi x3, zero, 525	# setup expected answer
		bne x1, x3, FAIL
		j CHKx2
		
SKIP:		jal x30, ROUTINE0
		addi x1, x1, 75		# should be skipped on return
		addi x1, x1, 37		# should be skipped on return
		addi x3, zero, 450	# setup expected answer
		bne x1, x3, FAIL
		### now check JALR stored return correctly ###
CHKx2:		addi x4, zero, 0x74
		bne x2, x4, FAIL
		j PASS	
	
ROUTINE0:	addi x1, x1, 150
		jalr x2, x30, -20				
ROUTINE:	addi x1, x1, 100
		jalr x0, x30, 0		# return
ROUTINE2:	addi x1, x1, 200
		jalr x0, x30, 8
	

PASS: 		addi ra, zero, 0xAA
		j PASS
	.align		64	

FAIL:		j FAIL
