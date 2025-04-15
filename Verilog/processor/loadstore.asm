# Test: Loads and stores using only RV32I instructions
# No pseudo-instructions. No la/lui/auipc. PC-relative labels.

##.data
##array:      .word 0x11111111, 0x22222222, 0x33333333, 0x44444444
##result:     .word 0, 0
##byte_data:  .byte 0xAA, 0xBB, 0xCC, 0xDD
##scratch:    .word 0

_start:


    #array will go from 0, 4, 8, 12 addr, result will be 16, 20, byte data will be 24, 25, 26, 27, and scratch will be 28

    #storing read only data manually
    li t1, 0x11111111
    andi t0, t0, 0 #set array index to 0
    jal t5, store_index
    li t1, 0x22222222
    jal t5, store_index
    li t1, 0x33333333
    jal t5, store_index
    li t1, 0x44444444
    jal t5, store_index
    addi t0, t0, 4
    addi t0, t0, 4
    andi t1, t1, 0
    addi t1, t1, 0xAA
    jal t5, store_byte
    addi t1, t1, 0xBB
    jal t5, store_byte
    addi t1, t1, 0xCC
    jal t5, store_byte
    addi t1, t1, 0xDD
    jal t5, store_byte
    j start_test
    
store_index: 
    sw t1, (t0)
    addi t0, t0, 4
    jalr zero, t5, 0
    
store_byte:
    sb t1, (t0)
    addi t0, t0, 1
    andi t1, t1, 0
    jalr zero, t5, 0


start_test:
    andi t5, t5, 0  #reset to 0 
    andi t1, t1, 0  #reset to 0 
    andi t0, t0, 0 #reset to 0 
    addi gp, zero, 0 #GLOABL OFFSET
    # Get base from global pointer
    addi t0, gp, 0         # t0 = &array
    lw t1, 4(t0)           # t1 = array[1] = 0x22222222

    # result[0] = t1
    addi t2, gp, 16
    sw t1, 0(t2)

    # Load byte_data[2]
    addi t3, gp, 24  # t3 = &byte_data
    lb t4, 2(t3)           # t4 = byte_data[2] = 0xCC (sign-extended to 0xFFFFFFCC)

    # Store t4 as byte into scratch
    addi t5, gp, 28     # t5 = &scratch
    sb t4, 0(t5)

    # Read back full word from scratch
    lw t6, 0(t5)                 # t6 should have 0x??...CC (THIS WILL WORK) 0x000000CC

    # result[1] = t6
    sw t6, 4(t2)

    # Store to array[0], [2], [3]
    sw t1, 0(t0)                 # array[0] = t1 0x22222222
    sw t4, 8(t0)                 # array[2] = t4 (partial store) 
    sw t6, 12(t0)                # array[3] = t6

    # Load final memory values into registers for testbench checking
    lw x10, 0(t0)                # x10 = array[0]
    lw x11, 4(t0)                # x11 = array[1]
    lw x12, 8(t0)                # x12 = array[2]
    lw x13, 12(t0)               # x13 = array[3]
    lw x14, 0(t2)                # x14 = result[0]
    lw x15, 4(t2)                # x15 = result[1]

done:
    j done