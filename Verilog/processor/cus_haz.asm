start:
	li t0,287454020
	ugs x5 #custom instruction for sending to PPU using t0
	li t1,1432778632
	uad x6 #custom instruction for sending to accelerator
	li t2,573785173
	snd x7 #custom instruction for sending to communication
	
	
	ldr x10 #LDR with dst of x10
	addi x10,x10,1
	rdi x12 #RDI to x12
	addi x12,x12,1
	sac x13 #SAC to x13
	addi x13,x13,1
	
	addi x31,x0,170
done:
	j done
	
	