#add fib(n-1) + fib(n-2)

start:		addi x1, x0, 43   #Calculate 10th Fib number
		addi x5, x0, 0    #Setting up address calculations
		addi x2, x0, 0    #x2 = fib(0)
		addi x3, x0, 1    #x3 = fib(1)
		sw x2, 0(x5)      #store at addr 0
		addi x5, x5, 4    #Go to next word
		sw x3, 0(x5)	   #Go to addr 4
		addi x4, x0, 0    #Loop Counter (i = 1)
		

fib_loop:	beq x4, x1, DONE  #(if i == n then we are done)
		addi x5, x5, 4    ##Go to next word
		add x6, x2, x3   #(calculate fib(n)
		sw x6, 0(x5)
		lw x2, -4(x5)
		lw x3, 0(x5)
		addi x4, x4, 1
		jal x0, fib_loop
		
		
		
		


DONE:	 
		lw x10,  0(x5) #44th fib 
		lw x11, -4(x5) #43 fib
		lw x12, -8(x5) #42 fib
		lw x13, -12(x5) #41
		lw x14, -16(x5) #40
		addi x31, x0, 1 #test is done

