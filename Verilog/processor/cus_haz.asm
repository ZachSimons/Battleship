start:
	li t0, 0x11223344
	#custom instruction for sending to PPU using t0
	li t1, 0x55667788
	#custom instruction for sending to accelerator
	li t2, 0x22334455
	#custom instruction for sending to communication
	
	
	#LDR with dst of x10
	addi x10, x10, 1
	#RDI to x12
	addi x12, x12, 1
	#SAC to x13
	addi x13, x13, 1
	
	addi x31, x0, 0xAA
done:
	j done
	
	