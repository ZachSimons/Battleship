#Testing J,JAL and JALR

#Testing Jumping works
		addi x1,x0,100 # load x1 with 100
		addi x2,x0,100 # load x2 with 100
		jal x30,ROUTINE # load x1 with non-zero
		sub x1,x1,x2 # should return here with x1 = 200 and x2 = 150. If failed then x1 will be 0	
		j SAVING


ROUTINE:
		addi x1,x1,100
		addi x2,x0,50
		jalr x0,0(x30)		#JALR with x0 is just jal. Return from function
		
SAVING:
		addi x3,x0,2
		ADDI x11,x11,239
		SW  x11,2(x3)
		LW x5,2(x3) #END of program

