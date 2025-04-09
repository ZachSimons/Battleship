ori x24, x24, 0xF
auipc x25, 0x12345 
addi x1,x1,1
addi x2,x2,2
add x3,x1,x2    
sub x4,x1,x2     
or x5,x1,x2   
slti x3, x1, 10    
sltiu x4, x1, 10   
xori x5, x1, 0xFF  
ori x6, x1, 0x7BC 
andi x7, x1, 0xF   
slli x8, x1, 2     
srli x9, x1, 1     
srai x10, x1, 1    
sll x3, x1, x2     
slt x4, x1, x2     
sltu x5, x1, x2    
xor x6, x1, x2     
srl x7, x1, x2     
sra x8, x1, x2     
or x9, x1, x2      
and x10, x1, x2    
lui x11, 0xDEADC
addi x11, x11, 0x7EF
    
    # Clear all registers except x0 (which is always zero)
    addi x1,  x0, 0    # clear register x1 (e.g., return address)
    addi x2,  x0, 0    # clear register x2 (stack pointer)
    addi x3,  x0, 0    # clear register x3
    addi x4,  x0, 0    # clear register x4
    addi x5,  x0, 0    # clear register x5
    addi x6,  x0, 0    # clear register x6
    addi x7,  x0, 0    # clear register x7
    addi x8,  x0, 0    # clear register x8
    addi x9,  x0, 0    # clear register x9
    addi x10, x0, 0    # clear register x10 (argument/return)
    addi x11, x0, 0    # clear register x11 (argument/return)
    addi x12, x0, 0    # clear register x12 (argument/return)
    addi x13, x0, 0    # clear register x13 (argument/return)
    addi x14, x0, 0    # clear register x14 (argument/return)
    addi x15, x0, 0    # clear register x15 (argument/return)
    addi x16, x0, 0    # clear register x16 (argument/return)
    addi x17, x0, 0    # clear register x17 (argument/return)
    addi x18, x0, 0    # clear register x18 (temporary or saved)
    addi x19, x0, 0    # clear register x19 (temporary or saved)
    addi x20, x0, 0    # clear register x20 (temporary or saved)
    addi x21, x0, 0    # clear register x21 (temporary or saved)
    addi x22, x0, 0    # clear register x22 (temporary or saved)
    addi x23, x0, 0    # clear register x23 (temporary or saved)
    addi x24, x0, 0    # clear register x24 (temporary or saved)
    addi x25, x0, 0    # clear register x25 (temporary or saved)
    addi x26, x0, 0    # clear register x26 (temporary or saved)
    addi x27, x0, 0    # clear register x27 (temporary or saved)
    addi x28, x0, 0    # clear register x28 (temporary or saved)
    addi x29, x0, 0    # clear register x29 (temporary or saved)
    addi x30, x0, 0    # clear register x30 (temporary or saved)
    addi x31, x0, 0    # clear register x31 (temporary or saved)
    
   # jal tests
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


	
