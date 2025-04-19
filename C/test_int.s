        .file   "test_int.c"
        .option nopic
        .attribute arch, "rv32i2p1"
        .attribute unaligned_access, 0
        .attribute stack_align, 16
        .text
        .globl  toSnd
        .section        .sbss,"aw",@nobits
        .align  2
        .type   toSnd, @object
        .size   toSnd, 4
toSnd:
        .zero   4
        .globl  activeSquare
        .align  2
        .type   activeSquare, @object
        .size   activeSquare, 4
activeSquare:
        .zero   4
        .globl  board
        .bss
        .align  2
        .type   board, @object
        .size   board, 400
board:
        .zero   400
        .text
        .align  2
        .globl  entry_point
        .type   entry_point, @function
entry_point:
 #APP
# 9 "test_int.c" 1
        j main
# 0 "" 2
# 10 "test_int.c" 1
        rdi a0
# 0 "" 2
# 11 "test_int.c" 1
        call interrupt_handler
# 0 "" 2
 #NO_APP
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
        .size   entry_point, .-entry_point
        .align  2
        .globl  interrupt_handler
        .type   interrupt_handler, @function
interrupt_handler:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        lw      a4,-20(s0)
        li      a5,102
        bne     a4,a5,.L3
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a5,a0
        beq     a5,zero,.L7
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,-32768
        addi    a4,a4,-1
        and     a4,a3,a4
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 19 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 20 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 21 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,-1
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,32768
        or      a4,a3,a4
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 25 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 26 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 27 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        j       .L7
.L3:
        lw      a4,-20(s0)
        li      a5,103
        bne     a4,a5,.L5
        lui     a5,%hi(activeSquare)
        lw      a4,%lo(activeSquare)(a5)
        li      a5,9
        ble     a4,a5,.L7
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,-32768
        addi    a4,a4,-1
        and     a4,a3,a4
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 33 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 34 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 35 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,-10
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,32768
        or      a4,a3,a4
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 39 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 40 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 41 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        j       .L7
.L5:
        lw      a4,-20(s0)
        li      a5,104
        bne     a4,a5,.L6
        lui     a5,%hi(activeSquare)
        lw      a4,%lo(activeSquare)(a5)
        li      a5,89
        bgt     a4,a5,.L7
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,-32768
        addi    a4,a4,-1
        and     a4,a3,a4
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 47 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 48 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 49 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,10
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,32768
        or      a4,a3,a4
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 53 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 54 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 55 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        j       .L7
.L6:
        lw      a4,-20(s0)
        li      a5,105
        bne     a4,a5,.L7
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a4,a0
        li      a5,8
        bgt     a4,a5,.L7
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,-32768
        addi    a4,a4,-1
        and     a4,a3,a4
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 61 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 62 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 63 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,1
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,32768
        or      a4,a3,a4
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 67 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 68 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 69 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
.L7:
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   interrupt_handler, .-interrupt_handler
        .align  2
        .globl  mult
        .type   mult, @function
mult:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      zero,-20(s0)
        sw      zero,-24(s0)
        j       .L9
.L10:
        lw      a4,-20(s0)
        lw      a5,-36(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L9:
        lw      a4,-24(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L10
        lw      a5,-20(s0)
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   mult, .-mult
        .align  2
        .globl  mod
        .type   mod, @function
mod:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        sw      a1,-24(s0)
        lw      a5,-20(s0)
        ble     a5,zero,.L17
        j       .L14
.L15:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        sub     a5,a4,a5
        sw      a5,-20(s0)
.L14:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        bgt     a4,a5,.L15
        j       .L16
.L18:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
.L17:
        lw      a5,-20(s0)
        blt     a5,zero,.L18
.L16:
        nop
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   mod, .-mod
        .align  2
        .globl  generate_encoding
        .type   generate_encoding, @function
generate_encoding:
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        addi    s0,sp,64
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      a2,-44(s0)
        sw      a3,-48(s0)
        sw      a4,-52(s0)
        sw      zero,-20(s0)
        lw      a5,-36(s0)
        slli    a5,a5,24
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a4,-20(s0)
        li      a5,12582912
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a4,-36(s0)
        li      a5,2
        beq     a4,a5,.L21
        lw      a4,-36(s0)
        li      a5,3
        bne     a4,a5,.L22
        lw      a4,-20(s0)
        li      a5,1048576
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L21
.L22:
        lw      a4,-36(s0)
        li      a5,4
        bne     a4,a5,.L23
        lw      a4,-20(s0)
        li      a5,2097152
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L21
.L23:
        lw      a4,-20(s0)
        li      a5,3145728
        or      a5,a4,a5
        sw      a5,-20(s0)
.L21:
        lw      a5,-44(s0)
        slli    a5,a5,17
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-48(s0)
        slli    a5,a5,16
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-52(s0)
        slli    a5,a5,15
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-20(s0)
        mv      a0,a5
        lw      ra,60(sp)
        lw      s0,56(sp)
        addi    sp,sp,64
        jr      ra
        .size   generate_encoding, .-generate_encoding
        .align  2
        .globl  place_ship
        .type   place_ship, @function
place_ship:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        sw      s1,36(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      a2,-44(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L26
        li      a5,10
        j       .L27
.L26:
        li      a5,1
.L27:
        sw      a5,-24(s0)
        sw      zero,-20(s0)
        j       .L28
.L29:
        lw      a1,-24(s0)
        lw      a0,-20(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a5,a5,a4
        sw      a5,-28(s0)
        lw      a1,-24(s0)
        lw      a0,-20(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     s1,a4,a5
        li      a4,0
        lw      a3,-44(s0)
        lw      a2,-20(s0)
        lw      a1,-28(s0)
        lw      a0,-36(s0)
        call    generate_encoding
        mv      a3,a0
        lui     a5,%hi(board)
        addi    a4,a5,%lo(board)
        slli    a5,s1,2
        add     a5,a4,a5
        sw      a3,0(a5)
        lui     a5,%hi(board)
        addi    a4,a5,%lo(board)
        lw      a5,-28(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 121 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 122 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 123 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L28:
        lw      a4,-20(s0)
        lw      a5,-36(s0)
        blt     a4,a5,.L29
        nop
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        lw      s1,36(sp)
        addi    sp,sp,48
        jr      ra
        .size   place_ship, .-place_ship
        .align  2
        .globl  main
        .type   main, @function
main:
        addi    sp,zero,2047
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        li      a2,0
        li      a1,22
        li      a0,2
        call    place_ship
        li      a2,1
        li      a1,54
        li      a0,3
        call    place_ship
        li      a2,0
        li      a1,66
        li      a0,3
        call    place_ship
        li      a2,1
        li      a1,10
        li      a0,4
        call    place_ship
        li      a2,0
        li      a1,82
        li      a0,5
        call    place_ship
        lui     a5,%hi(board)
        addi    a5,a5,%lo(board)
        lw      a4,220(a5)
        li      a5,32768
        or      a4,a4,a5
        lui     a5,%hi(board)
        addi    a5,a5,%lo(board)
        sw      a4,220(a5)
        lui     a5,%hi(board)
        addi    a5,a5,%lo(board)
        lw      a4,220(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 135 "test_int.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 136 "test_int.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 137 "test_int.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        li      a5,0
        mv      a0,a5
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
        .size   main, .-main
        .ident  "GCC: (g04696df09) 14.2.0"
        .section        .note.GNU-stack,"",@progbits