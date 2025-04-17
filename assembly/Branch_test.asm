#Testing J,JAL and JALR

#Testing Jumping works
		addi x1,x0,100 # load x1 with 100
		addi x2,x0,100 # load x2 with 100
		#x1 = 100,x2 = 100
		AUIPC x31,0
		BEQ x1,x2,PASS
		BNE x1,x2,FAIL
		
		addi x1,x1,-50
		#x1 = 50,x2 = 100
		AUIPC x31,0
		BNE x1,x2,PASS
		BEQ x1,x2,FAIL
		
		
		addi x3,x0,-1
		addi x4,x0,1
		#x3 = -1,x4 = 1
		AUIPC x31,0
		BLT x3,x4,PASS
		BGE x3,x4,FAIL
		
		#x3 = -1,x4 = 1
		AUIPC x31,0
		BGE x4,x3,PASS
		BLT x4,x3,FAIL
		
		#x3 = -1,x4 = 1
		AUIPC x31,0
		BLTU x3,x4,FAIL
		BGEU x3,x4,PASS
		
		#x3 = -1,x4 = 1
		AUIPC x31,0
		BGEU x4,x3,FAIL
		BLTU x4,x3,PASS
		j DONE
	
PASS:
		addi x28,x28,1
		jalr x0,12(x31) 


FAIL:
		addi x29,x29,1
		jalr x0,12(x31)
		
DONE:
		addi x27,x0,1

	