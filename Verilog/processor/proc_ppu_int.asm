# Increment register and update PPU with value after each increment.
# Loop through previous 2 operations until register has value 35, then Jump to done

start:

    addi x11, x0, 35

loop:
    addi x10, x10, 1
    ugs x10,
    bne x10, x11 loop

done:
    j done
