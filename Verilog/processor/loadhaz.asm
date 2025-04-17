# load_hazard_test_small_addrs.s
# RV32I test for load-use hazards at low memory addresses

.text
.globl _start
_start:

    ####################################
    # Manually write known values to memory
    # Mem[0] = 0x10 (pointer to 0x10)
    # Mem[4] = 0x14 (pointer to 0x14)
    # Mem[0x10] = 0x11223344
    # Mem[0x14] = 0x55667788
    ####################################

    li t1,16         # first pointer
    sw t1,0(x0)        # Mem[0] = 0x10

    li t2,20         # second pointer
    sw t2,4(x0)        # Mem[4] = 0x14

    li t3,287454020   # value at 0x10
    sw t3,16(x0)

    li t4,1432778632   # value at 0x14
    sw t4,20(x0)

    j load

    done: 
        addi x31,x0,170
        j end

    ####################################
    # Load hazard chain
    # x5 = Mem[0] = 0x10
    # x6 = Mem[x5] = 0x11223344
    # x7 = Mem[4] = 0x14
    # x8 = Mem[x7] = 0x55667788
    ####################################

    load:
        lw x13,0(x0)        # x5 = 0x10
        lw x14,0(x13)        # x6 = Mem[0x10] = 0x11223344 (load-use hazard)

        lw x15,4(x0)        # x7 = 0x14
        lw x16,0(x15)        # x8 = Mem[0x14] = 0x55667788 (another hazard)

    j done

    addi x5,x0,4095

    ####################################
    # Final register values for testbench to check
    ####################################

    # x13 = 0x10
    # x14 = 0x11223344
    # x15 = 0x14
    # x16 = 0x55667788

end:
    j end
