#add fib(n-1) + fib(n-2)

start:
		addi x1,x0,10   #Calculate 10th Fib number
		addi x5,x0,0    #Setting up address calculations
		addi x2,x0,0    #x2 = fib(0)
		addi x3,x0,1    #x3 = fib(1)
		sw x2,0(x5)      #store at addr 0
		addi x5,x5,4    #Go to next word
		sw x3,0(x5)	   #Go to addr 4
		addi x4,x0,0    #Loop Counter (i = 1)
		

fib_loop:
		beq x4,x1,DONE  #(if i == n then we are done)
		addi x5,x5,4    ##Go to next word
		add x6,x2,x3   #(calculate fib(n)
		sw x6,0(x5)
		lw x2,-4(x5)
		lw x3,0(x5)
		addi x4,x4,1
		jal x0,fib_loop


DONE:
		addi x31,x0,1

