# Test: Loads and stores using only RV32I instructions
# No pseudo-instructions. No la/lui/auipc. PC-relative labels.

.data
array:      .word 0x11111111, 0x22222222, 0x33333333, 0x44444444
result:     .word 0, 0
byte_data:  .byte 0xAA, 0xBB, 0xCC, 0xDD
scratch:    .word 0

.text
.globl _start
_start:

    # Get base address using auipc + addi (PC-relative)
    lui t0, %hi(array)           # t0 = PC
    addi t0, t0, %lo(array)      # t0 = &array
    lw t1, 4(t0)                 # t1 = array[1] = 0x22222222

    # result[0] = t1
    lui t2, %hi(result)
    addi t2, t2, %lo(result)
    sw t1, 0(t2)

    # Load byte_data[2]
    lui t3, %hi(byte_data)
    addi t3, t3, %lo(byte_data)   # t3 = &byte_data
    lb t4, 2(t3)                 # t4 = byte_data[2] = 0xCC (sign-extended to 0xFFFFFFCC)

    # Store t4 as byte into scratch
    lui t5, %hi(scratch)
    addi t5, t5, %lo(scratch)     # t5 = &scratch
    sb t4, 0(t5)

    # Read back full word from scratch
    lw t6, 0(t5)                 # t6 should have 0x??...CC

    # result[1] = t6
    sw t6, 4(t2)

    # Store to array[0], [2], [3]
    sw t1, 0(t0)                 # array[0] = t1
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
