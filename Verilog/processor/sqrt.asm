########################################################
# Without mul instr


main:
	addi t4,x0,1600	# value to take sqrt of (x)
	sw t4,0(t5)		# store x at address 0 (start of data region)
        # call floor(squrt(x))
        lw  a0,0(t6)             # load argument x
        jal ra,floor_sqrt    # call floor_sqrt(x)
        
floor_sqrt:
        li   t0,0            # unsigned int s = 0;
        li   t1,1            # unsigned int i = 1;
        slli t1,t1,15       # i = i << 15
for_next_bit:
        beqz t1,done # if i == 0 goto next_bit_end
        add  t2,t0,t1       # t2 = s + i
        mv   t4,t2           # move (s + i) into a0 (input for square)
	jal  ra,square       # call square function
	mv   t3,a7           # move result from a0 into t3
        bltu a0,t3,if_x_is_less_than_t3 # if a0 < t3 then don't add
        add  t0,t0,t1       # s = s + i
if_x_is_less_than_t3:
        srli t1,t1,1        # i = i >> 1
        j for_next_bit        # goto for_next_bit
        
# square(a0) -> a0 = a0 * a0
square:
    li t5,0          # result = 0
    li t6,0          # i = 0

square_loop:
    beq t6,t4,square_end  # if i == x,done
    add t5,t5,t4          # result += x
    addi t6,t6,1          # i++
    j square_loop

square_end:
    mv a7,t5         # return result in a0
    ret
done:
	mv a0,t0
	addi t4,x0,1
