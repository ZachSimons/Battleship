j main
#interrupt handler
	ble x7, x31 rsi #Go to rsi
	bge x7, x31 rti #go to rti
rsi:	
	addi x2, x2, 1     #2 used to count rsi
	add x7, x2, x3
	auipc x26, 0
	jalr x0, 28(x26)     #insert rsi instruction jumping to main loop 
	ori  x28, x28, 0
rti:
	addi x3, x3, 1     #3 used to count rti
	add x7, x2, x3
	addi x0, x0, 0    #insert rti instruction
	ori  x28, x28, 0
			    #complete test when 6 interrups have been handeled





main:  
	addi x29, x0, 1        #Branch only on odd
	addi x31, x0, 3      
MainLoop:
	addi x28, x28, 1       #add 1 to x28
	ori  x28, x28, 0        #Does nothing
	and x30, x28, x29      #mask for branch
	beq x30, x29, MainLoop #Branch back to mainloop if odd
	ori  x28, x28, 0        #Does nothing
	sll x28, x28, x0       #Does nothing
	srl x28, x28, x0       #Does nothing
	
	#padding instructions		
	addi x1, x1, 1
	addi x1, x1, 1
	addi x1, x1, 1	
	j MainLoop
	
	
	#will have to manually check if it's returning to correct instruction
	
