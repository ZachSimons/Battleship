        .file   "basic_test_code.c"
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
        .globl  myTurn
        .align  2
        .type   myTurn, @object
        .size   myTurn, 4
myTurn:
        .zero   4
        .globl  board
        .bss
        .align  2
        .type   board, @object
        .size   board, 400
board:
        .zero   400
        .globl  my_board
        .align  2
        .type   my_board, @object
        .size   my_board, 400
my_board:
        .zero   400
        .globl  ship_sizes
        .align  2
        .type   ship_sizes, @object
        .size   ship_sizes, 20
ship_sizes:
        .zero   20
        .globl  my_positions
        .align  2
        .type   my_positions, @object
        .size   my_positions, 20
my_positions:
        .zero   20
        .globl  my_sunk
        .align  2
        .type   my_sunk, @object
        .size   my_sunk, 20
my_sunk:
        .zero   20
        .globl  enemy_sunk
        .align  2
        .type   enemy_sunk, @object
        .size   enemy_sunk, 20
enemy_sunk:
        .zero   20
        .globl  possible_positions
        .align  2
        .type   possible_positions, @object
        .size   possible_positions, 4000
possible_positions:
        .zero   4000
        .globl  hit_counts
        .align  2
        .type   hit_counts, @object
        .size   hit_counts, 400
hit_counts:
        .zero   400
        .globl  ai_target
        .section        .sbss
        .align  2
        .type   ai_target, @object
        .size   ai_target, 4
ai_target:
        .zero   4
        .globl  old_ai_target
        .align  2
        .type   old_ai_target, @object
        .size   old_ai_target, 4
old_ai_target:
        .zero   4
        .globl  accelerator_ran
        .align  2
        .type   accelerator_ran, @object
        .size   accelerator_ran, 4
accelerator_ran:
        .zero   4
        .text
        .align  2
        .globl  entry_point
        .type   entry_point, @function
entry_point:
        j main
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        sw      a0,4(sp)
        addi    s0,sp,16
 #APP
# 32 "basic_test_code.c" 1
# 0 "" 2
# 33 "basic_test_code.c" 1
        rdi a0
# 0 "" 2
# 34 "basic_test_code.c" 1
        call exception_handler
# 0 "" 2
# 35 "basic_test_code.c" 1
# 0 "" 2
 #NO_APP
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        lw      a0,4(sp)
        addi    sp,sp,16
        rti
        .size   entry_point, .-entry_point
        .align  2
        .globl  exception_handler
        .type   exception_handler, @function
exception_handler:
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        addi    s0,sp,64
        sw      a0,-52(s0)
        lw      a4,-52(s0)
        li      a5,99
        bgt     a4,a5,.L3
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,12582912
        bne     a4,a5,.L4
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-4194304
        addi    a5,a5,-1
        and     a4,a4,a5
        lui     a5,%hi(my_board)
        addi    a3,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        call    check_sunk
        sw      a0,-44(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L5
        lw      a5,-44(s0)
        addi    a5,a5,-1
        sw      a5,-44(s0)
        call    check_lose
        mv      a5,a0
        beq     a5,zero,.L6
        lw      a5,-44(s0)
        slli    a4,a5,8
        li      a5,131072
        or      a4,a4,a5
        lui     a5,%hi(my_positions)
        addi    a3,a5,%lo(my_positions)
        lw      a5,-44(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a5,0(a5)
        or      a5,a4,a5
        mv      a0,a5
        call    send_board_value
        li      a5,4096
        addi    a0,a5,-2048
        call    send_ppu_value
        j       .L23
.L6:
        lw      a5,-44(s0)
        slli    a4,a5,8
        li      a5,65536
        or      a4,a4,a5
        lui     a5,%hi(my_positions)
        addi    a3,a5,%lo(my_positions)
        lw      a5,-44(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a5,0(a5)
        or      a5,a4,a5
        mv      a0,a5
        call    send_board_value
        li      a0,12288
        call    send_ppu_value
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        j       .L23
.L5:
        li      a0,101
        call    send_board_value
        li      a0,12288
        call    send_ppu_value
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        j       .L23
.L4:
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,4194304
        or      a4,a4,a5
        lui     a5,%hi(my_board)
        addi    a3,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        li      a0,100
        call    send_board_value
        li      a0,12288
        call    send_ppu_value
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        j       .L23
.L3:
        lw      a4,-52(s0)
        li      a5,100
        bne     a4,a5,.L8
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        li      a0,8192
        call    send_ppu_value
        lui     a5,%hi(accelerator_ran)
        sw      zero,%lo(accelerator_ran)(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,4227072
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
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        j       .L23
.L8:
        lw      a4,-52(s0)
        li      a5,101
        bne     a4,a5,.L9
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        li      a0,8192
        call    send_ppu_value
        lui     a5,%hi(accelerator_ran)
        sw      zero,%lo(accelerator_ran)(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a4,8421376
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
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        j       .L23
.L9:
        lw      a4,-52(s0)
        li      a5,106
        bgt     a4,a5,.L10
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
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        lw      a4,-52(s0)
        li      a5,102
        bne     a4,a5,.L11
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a5,a0
        beq     a5,zero,.L12
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,-1
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L12
.L11:
        lw      a4,-52(s0)
        li      a5,103
        bne     a4,a5,.L13
        lui     a5,%hi(activeSquare)
        lw      a4,%lo(activeSquare)(a5)
        li      a5,9
        ble     a4,a5,.L12
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,-10
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L12
.L13:
        lw      a4,-52(s0)
        li      a5,104
        bne     a4,a5,.L14
        lui     a5,%hi(activeSquare)
        lw      a4,%lo(activeSquare)(a5)
        li      a5,89
        bgt     a4,a5,.L12
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,10
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L12
.L14:
        lw      a4,-52(s0)
        li      a5,105
        bne     a4,a5,.L15
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a4,a0
        li      a5,8
        bgt     a4,a5,.L12
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,1
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L12
.L15:
        lw      a4,-52(s0)
        li      a5,106
        bne     a4,a5,.L12
        lui     a5,%hi(myTurn)
        lw      a5,%lo(myTurn)(a5)
        beq     a5,zero,.L12
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a5,a4,a5
        bne     a5,zero,.L12
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        mv      a0,a5
        call    send_board_value
.L12:
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
        lui     a5,%hi(activeSquare)
        lw      a3,%lo(activeSquare)(a5)
        lui     a5,%hi(ai_target)
        lw      a5,%lo(ai_target)(a5)
        bne     a3,a5,.L16
        li      a5,16384
        j       .L17
.L16:
        li      a5,0
.L17:
        or      a5,a5,a4
        mv      a0,a5
        call    send_ppu_value
        j       .L23
.L10:
        lw      a4,-52(s0)
        li      a5,107
        bne     a4,a5,.L18
        call    reset_program
        j       .L23
.L18:
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        li      a0,8192
        call    send_ppu_value
        lui     a5,%hi(accelerator_ran)
        sw      zero,%lo(accelerator_ran)(a5)
        lw      a5,-52(s0)
        srai    a5,a5,8
        andi    a5,a5,255
        sw      a5,-24(s0)
        lw      a5,-52(s0)
        andi    a5,a5,255
        sw      a5,-28(s0)
        li      a1,100
        lw      a0,-28(s0)
        call    mod
        sw      a0,-32(s0)
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L19
        li      a5,10
        j       .L20
.L19:
        li      a5,1
.L20:
        sw      a5,-36(s0)
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-24(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,-28(s0)
        sw      a4,0(a5)
        sw      zero,-20(s0)
        j       .L21
.L22:
        lw      a1,-20(s0)
        lw      a0,-36(s0)
        call    mult
        mv      a4,a0
        lw      a5,-32(s0)
        add     a5,a5,a4
        sw      a5,-40(s0)
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-24(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a1,0(a5)
        lw      a5,-28(s0)
        slti    a5,a5,100
        seqz    a5,a5
        andi    a5,a5,255
        mv      a3,a5
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lw      a4,-40(s0)
        sub     a5,a4,a5
        seqz    a5,a5
        andi    a5,a5,255
        mv      a6,a5
        mv      a5,a3
        lw      a4,-20(s0)
        lw      a3,-40(s0)
        li      a2,3
        li      a0,0
        call    generate_encoding
        mv      a3,a0
        lui     a5,%hi(board)
        addi    a4,a5,%lo(board)
        lw      a5,-40(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      a3,0(a5)
        lui     a5,%hi(board)
        addi    a4,a5,%lo(board)
        lw      a5,-40(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L21:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-24(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-20(s0)
        blt     a4,a5,.L22
        lw      a4,-52(s0)
        li      a5,131072
        and     a5,a4,a5
        beq     a5,zero,.L23
        li      a5,4096
        addi    a0,a5,-1024
        call    send_ppu_value
.L23:
        nop
        lw      ra,60(sp)
        lw      s0,56(sp)
        addi    sp,sp,64
        jr      ra
        .size   exception_handler, .-exception_handler
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
        ble     a5,zero,.L29
        j       .L26
.L27:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        sub     a5,a4,a5
        sw      a5,-20(s0)
.L26:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        bge     a4,a5,.L27
        j       .L28
.L30:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
.L29:
        lw      a5,-20(s0)
        blt     a5,zero,.L30
.L28:
        lw      a5,-20(s0)
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   mod, .-mod
        .align  2
        .globl  rand
        .type   rand, @function
rand:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
 #APP
# 141 "basic_test_code.c" 1
        ldr a0
# 0 "" 2
 #NO_APP
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   rand, .-rand
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
        j       .L35
.L36:
        lw      a4,-20(s0)
        lw      a5,-36(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L35:
        lw      a4,-24(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L36
        lw      a5,-20(s0)
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   mult, .-mult
        .align  2
        .globl  send_ppu_value
        .type   send_ppu_value, @function
send_ppu_value:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        lui     a5,%hi(toSnd)
        lw      a4,-20(s0)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 155 "basic_test_code.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 156 "basic_test_code.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 157 "basic_test_code.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   send_ppu_value, .-send_ppu_value
        .align  2
        .globl  send_board_value
        .type   send_board_value, @function
send_board_value:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        lui     a5,%hi(toSnd)
        lw      a4,-20(s0)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 162 "basic_test_code.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 163 "basic_test_code.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 164 "basic_test_code.c" 1
        snd a0
# 0 "" 2
 #NO_APP
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   send_board_value, .-send_board_value
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
        sw      a5,-56(s0)
        sw      a6,-60(s0)
        lw      a5,-36(s0)
        slli    a5,a5,31
        sw      a5,-20(s0)
        lw      a5,-48(s0)
        slli    a5,a5,24
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-44(s0)
        slli    a5,a5,22
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a4,-40(s0)
        li      a5,2
        beq     a4,a5,.L42
        lw      a4,-40(s0)
        li      a5,3
        bne     a4,a5,.L43
        lw      a4,-20(s0)
        li      a5,1048576
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L42
.L43:
        lw      a4,-40(s0)
        li      a5,4
        bne     a4,a5,.L44
        lw      a4,-20(s0)
        li      a5,2097152
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L42
.L44:
        lw      a4,-20(s0)
        li      a5,3145728
        or      a5,a4,a5
        sw      a5,-20(s0)
.L42:
        lw      a5,-52(s0)
        slli    a5,a5,17
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-56(s0)
        slli    a5,a5,16
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-60(s0)
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
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        sw      s1,52(sp)
        addi    s0,sp,64
        sw      a0,-52(s0)
        sw      a1,-56(s0)
        sw      a2,-60(s0)
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-28(s0)
        lw      a5,-60(s0)
        beq     a5,zero,.L47
        li      a5,10
        j       .L48
.L47:
        li      a5,1
.L48:
        sw      a5,-32(s0)
        lw      a5,-60(s0)
        beq     a5,zero,.L49
        lw      a5,-28(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L50
        li      a5,0
        j       .L51
.L49:
        li      a1,10
        lw      a0,-52(s0)
        call    mod
        mv      s1,a0
        lw      a5,-28(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-32(s0)
        call    mult
        mv      a5,a0
        add     a4,s1,a5
        li      a5,9
        ble     a4,a5,.L50
        li      a5,0
        j       .L51
.L50:
        sw      zero,-20(s0)
        j       .L52
.L54:
        lw      a1,-20(s0)
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a5,a4,a5
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,12582912
        bne     a4,a5,.L53
        li      a5,0
        j       .L51
.L53:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L52:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L54
        lw      a1,-60(s0)
        li      a0,100
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a4,a4,a5
        lui     a5,%hi(my_positions)
        addi    a3,a5,%lo(my_positions)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        sw      zero,-24(s0)
        j       .L55
.L56:
        lw      a1,-24(s0)
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a5,a5,a4
        sw      a5,-36(s0)
        lw      a1,-32(s0)
        lw      a0,-24(s0)
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a3,a4,a5
        li      a6,0
        lw      a5,-60(s0)
        lw      a4,-24(s0)
        li      a2,3
        lw      a1,-28(s0)
        li      a0,1
        call    generate_encoding
        mv      a3,a0
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-36(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      a3,0(a5)
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-36(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L55:
        lw      a4,-24(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L56
        li      a5,1
.L51:
        mv      a0,a5
        lw      ra,60(sp)
        lw      s0,56(sp)
        lw      s1,52(sp)
        addi    sp,sp,64
        jr      ra
        .size   place_ship, .-place_ship
        .align  2
        .globl  check_sunk
        .type   check_sunk, @function
check_sunk:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      zero,-20(s0)
        j       .L58
.L67:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        bne     a5,zero,.L59
        lui     a5,%hi(my_positions)
        addi    a4,a5,%lo(my_positions)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        li      a1,100
        mv      a0,a5
        call    mod
        sw      a0,-32(s0)
        lui     a5,%hi(my_positions)
        addi    a4,a5,%lo(my_positions)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,99
        ble     a4,a5,.L60
        li      a5,10
        j       .L61
.L60:
        li      a5,1
.L61:
        sw      a5,-36(s0)
        li      a5,1
        sw      a5,-24(s0)
        sw      zero,-28(s0)
        j       .L62
.L65:
        lw      a1,-28(s0)
        lw      a0,-36(s0)
        call    mult
        mv      a4,a0
        lw      a5,-32(s0)
        add     a5,a4,a5
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,8388608
        beq     a4,a5,.L63
        sw      zero,-24(s0)
        j       .L64
.L63:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L62:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-28(s0)
        blt     a4,a5,.L65
.L64:
        lw      a5,-24(s0)
        beq     a5,zero,.L59
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        li      a4,1
        sw      a4,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        j       .L66
.L59:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L58:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L67
        li      a5,0
.L66:
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   check_sunk, .-check_sunk
        .align  2
        .globl  check_lose
        .type   check_lose, @function
check_lose:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L69
.L72:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        bne     a5,zero,.L70
        li      a5,0
        j       .L71
.L70:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L69:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L72
        li      a5,1
.L71:
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   check_lose, .-check_lose
        .align  2
        .globl  reset_program
        .type   reset_program, @function
reset_program:
 #APP
# 243 "basic_test_code.c" 1
        addi sp,zero,0
# 0 "" 2
# 244 "basic_test_code.c" 1
        la a0,main
# 0 "" 2
# 245 "basic_test_code.c" 1
        rsi a0
# 0 "" 2
 #NO_APP
        .size   reset_program, .-reset_program
        .align  2
        .globl  initialize_boards
        .type   initialize_boards, @function
initialize_boards:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L75
.L76:
        lw      a5,-20(s0)
        slli    a4,a5,24
        lui     a5,%hi(board)
        addi    a3,a5,%lo(board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lw      a5,-20(s0)
        slli    a4,a5,24
        li      a5,-2147483648
        or      a5,a4,a5
        mv      a3,a5
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      a3,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L75:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L76
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   initialize_boards, .-initialize_boards
        .align  2
        .globl  clear_possible_positions
        .type   clear_possible_positions, @function
clear_possible_positions:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L78
.L83:
        sw      zero,-24(s0)
        j       .L79
.L82:
        sw      zero,-28(s0)
        j       .L80
.L81:
        lw      a1,-24(s0)
        li      a0,100
        call    mult
        mv      a4,a0
        lw      a5,-28(s0)
        add     a2,a4,a5
        lui     a5,%hi(possible_positions)
        addi    a3,a5,%lo(possible_positions)
        lw      a4,-20(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a2
        slli    a5,a5,2
        add     a5,a3,a5
        sw      zero,0(a5)
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L80:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L81
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L79:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L82
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L78:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L83
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   clear_possible_positions, .-clear_possible_positions
        .align  2
        .globl  clear_hit_counts
        .type   clear_hit_counts, @function
clear_hit_counts:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L85
.L86:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      zero,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L85:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L86
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   clear_hit_counts, .-clear_hit_counts
        .align  2
        .globl  clear_accelerator_data
        .type   clear_accelerator_data, @function
clear_accelerator_data:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        call    clear_possible_positions
        call    clear_hit_counts
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
        .size   clear_accelerator_data, .-clear_accelerator_data
        .align  2
        .globl  check_valid_position
        .type   check_valid_position, @function
check_valid_position:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        sw      s1,36(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      a2,-44(s0)
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-36(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-24(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L89
        li      a5,10
        j       .L90
.L89:
        li      a5,1
.L90:
        sw      a5,-28(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L91
        lw      a5,-24(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L92
        li      a5,0
        j       .L93
.L91:
        li      a1,10
        lw      a0,-40(s0)
        call    mod
        mv      s1,a0
        lw      a5,-24(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-28(s0)
        call    mult
        mv      a5,a0
        add     a4,s1,a5
        li      a5,9
        ble     a4,a5,.L92
        li      a5,0
        j       .L93
.L92:
        sw      zero,-20(s0)
        j       .L94
.L97:
        lw      a1,-20(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a5,a4,a5
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a5,a4,a5
        sw      a5,-32(s0)
        lw      a4,-32(s0)
        li      a5,4194304
        beq     a4,a5,.L95
        lw      a4,-32(s0)
        li      a5,12582912
        bne     a4,a5,.L96
.L95:
        li      a5,0
        j       .L93
.L96:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L94:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        blt     a4,a5,.L97
        li      a5,1
.L93:
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        lw      s1,36(sp)
        addi    sp,sp,48
        jr      ra
        .size   check_valid_position, .-check_valid_position
        .align  2
        .globl  square_in_configuration
        .type   square_in_configuration, @function
square_in_configuration:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      zero,-20(s0)
        j       .L99
.L106:
        lw      a5,-20(s0)
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,99
        ble     a4,a5,.L100
        li      a5,10
        j       .L101
.L100:
        li      a5,1
.L101:
        sw      a5,-28(s0)
        lw      a5,-20(s0)
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a5,a4,a5
        lw      a5,0(a5)
        li      a1,100
        mv      a0,a5
        call    mod
        sw      a0,-32(s0)
        sw      zero,-24(s0)
        j       .L102
.L105:
        lw      a1,-24(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-32(s0)
        add     a5,a4,a5
        lw      a4,-40(s0)
        bne     a4,a5,.L103
        li      a5,1
        j       .L104
.L103:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L102:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-24(s0)
        blt     a4,a5,.L105
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L99:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L106
        li      a5,0
.L104:
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   square_in_configuration, .-square_in_configuration
        .align  2
        .globl  calculate_overlap
        .type   calculate_overlap, @function
calculate_overlap:
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        sw      s1,52(sp)
        addi    s0,sp,64
        sw      a0,-52(s0)
        sw      a1,-56(s0)
        sw      a2,-60(s0)
        sw      a3,-64(s0)
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-28(s0)
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-60(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-32(s0)
        lw      a4,-56(s0)
        li      a5,99
        ble     a4,a5,.L108
        li      a5,10
        j       .L109
.L108:
        li      a5,1
.L109:
        sw      a5,-36(s0)
        lw      a4,-64(s0)
        li      a5,99
        ble     a4,a5,.L110
        li      a5,10
        j       .L111
.L110:
        li      a5,1
.L111:
        sw      a5,-40(s0)
        li      a1,100
        lw      a0,-56(s0)
        call    mod
        sw      a0,-44(s0)
        li      a1,100
        lw      a0,-64(s0)
        call    mod
        sw      a0,-48(s0)
        sw      zero,-20(s0)
        j       .L112
.L117:
        sw      zero,-24(s0)
        j       .L113
.L116:
        lw      a1,-20(s0)
        lw      a0,-36(s0)
        call    mult
        mv      a4,a0
        lw      a5,-44(s0)
        add     s1,a4,a5
        lw      a1,-24(s0)
        lw      a0,-40(s0)
        call    mult
        mv      a4,a0
        lw      a5,-48(s0)
        add     a5,a4,a5
        bne     s1,a5,.L114
        li      a5,0
        j       .L115
.L114:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L113:
        lw      a4,-24(s0)
        lw      a5,-32(s0)
        blt     a4,a5,.L116
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L112:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L117
        li      a5,1
.L115:
        mv      a0,a5
        lw      ra,60(sp)
        lw      s0,56(sp)
        lw      s1,52(sp)
        addi    sp,sp,64
        jr      ra
        .size   calculate_overlap, .-calculate_overlap
        .align  2
        .globl  check_valid_configuration
        .type   check_valid_configuration, @function
check_valid_configuration:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      zero,-20(s0)
        j       .L119
.L122:
        lui     a5,%hi(board)
        addi    a4,a5,%lo(board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,8388608
        bne     a4,a5,.L120
        lw      a1,-20(s0)
        lw      a0,-36(s0)
        call    square_in_configuration
        mv      a5,a0
        bne     a5,zero,.L120
        li      a5,0
        j       .L121
.L120:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L119:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L122
        sw      zero,-24(s0)
        j       .L123
.L127:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
        j       .L124
.L126:
        lw      a5,-24(s0)
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a5,a4,a5
        lw      a1,0(a5)
        lw      a5,-28(s0)
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a3,a5
        lw      a2,-28(s0)
        lw      a0,-24(s0)
        call    calculate_overlap
        mv      a5,a0
        bne     a5,zero,.L125
        li      a5,0
        j       .L121
.L125:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L124:
        lw      a4,-28(s0)
        li      a5,4
        ble     a4,a5,.L126
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L123:
        lw      a4,-24(s0)
        li      a5,3
        ble     a4,a5,.L127
        li      a5,1
.L121:
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   check_valid_configuration, .-check_valid_configuration
        .align  2
        .globl  run_accelerator
        .type   run_accelerator, @function
run_accelerator:
        addi    sp,sp,-80
        sw      ra,76(sp)
        sw      s0,72(sp)
        sw      s1,68(sp)
        addi    s0,sp,80
        call    clear_accelerator_data
        sw      zero,-20(s0)
        j       .L129
.L137:
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        beq     a4,a5,.L130
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a2,0(a5)
        lui     a5,%hi(possible_positions)
        addi    a3,a5,%lo(possible_positions)
        lw      a4,-20(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a2
        slli    a5,a5,2
        add     a5,a3,a5
        li      a4,1
        sw      a4,0(a5)
        j       .L131
.L130:
        sw      zero,-24(s0)
        j       .L132
.L136:
        sw      zero,-28(s0)
        j       .L133
.L135:
        lw      a2,-24(s0)
        lw      a1,-28(s0)
        lw      a0,-20(s0)
        call    check_valid_position
        mv      a5,a0
        beq     a5,zero,.L134
        lw      a1,-24(s0)
        li      a0,100
        call    mult
        mv      a4,a0
        lw      a5,-28(s0)
        add     a2,a4,a5
        lui     a5,%hi(possible_positions)
        addi    a3,a5,%lo(possible_positions)
        lw      a4,-20(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a2
        slli    a5,a5,2
        add     a5,a3,a5
        li      a4,1
        sw      a4,0(a5)
.L134:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L133:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L135
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L132:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L136
.L131:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L129:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L137
        sw      zero,-32(s0)
        j       .L138
.L151:
        sw      zero,-36(s0)
        j       .L139
.L141:
        call    rand
        mv      a5,a0
        li      a1,200
        mv      a0,a5
        call    mod
        mv      a3,a0
        lw      a4,-36(s0)
        addi    a5,s0,-80
        slli    a4,a4,2
        add     a5,a4,a5
        sw      a3,0(a5)
        lw      a4,-36(s0)
        addi    a5,s0,-80
        slli    a4,a4,2
        add     a5,a4,a5
        lw      a2,0(a5)
        lui     a5,%hi(possible_positions)
        addi    a3,a5,%lo(possible_positions)
        lw      a4,-36(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a2
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a5,0(a5)
        bne     a5,zero,.L140
        lw      a5,-36(s0)
        addi    a5,a5,-1
        sw      a5,-36(s0)
.L140:
        lw      a5,-36(s0)
        addi    a5,a5,1
        sw      a5,-36(s0)
.L139:
        lw      a4,-36(s0)
        li      a5,4
        ble     a4,a5,.L141
        addi    a5,s0,-80
        mv      a0,a5
        call    check_valid_configuration
        mv      a5,a0
        bne     a5,zero,.L142
        lw      a5,-32(s0)
        addi    a5,a5,-1
        sw      a5,-32(s0)
        j       .L143
.L142:
        sw      zero,-40(s0)
        j       .L144
.L150:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-40(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sb      a5,-57(s0)
        lw      a4,-40(s0)
        addi    a5,s0,-80
        slli    a4,a4,2
        add     a5,a4,a5
        lw      a5,0(a5)
        li      a1,100
        mv      a0,a5
        call    mod
        mv      a5,a0
        sb      a5,-58(s0)
        lw      a4,-40(s0)
        addi    a5,s0,-80
        slli    a4,a4,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,99
        ble     a4,a5,.L145
        li      a5,10
        j       .L146
.L145:
        li      a5,1
.L146:
        sb      a5,-59(s0)
        sw      zero,-44(s0)
        j       .L147
.L149:
        lbu     s1,-58(s0)
        lbu     a5,-59(s0)
        lw      a1,-44(s0)
        mv      a0,a5
        call    mult
        mv      a5,a0
        add     a5,s1,a5
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a5,a4,a5
        bne     a5,zero,.L148
        lbu     s1,-58(s0)
        lbu     a5,-59(s0)
        lw      a1,-44(s0)
        mv      a0,a5
        call    mult
        mv      a5,a0
        add     a5,s1,a5
        lui     a4,%hi(hit_counts)
        addi    a3,a4,%lo(hit_counts)
        slli    a4,a5,2
        add     a4,a3,a4
        lw      a4,0(a4)
        addi    a4,a4,1
        lui     a3,%hi(hit_counts)
        addi    a3,a3,%lo(hit_counts)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
.L148:
        lw      a5,-44(s0)
        addi    a5,a5,1
        sw      a5,-44(s0)
.L147:
        lbu     a5,-57(s0)
        lw      a4,-44(s0)
        blt     a4,a5,.L149
        lw      a5,-40(s0)
        addi    a5,a5,1
        sw      a5,-40(s0)
.L144:
        lw      a4,-40(s0)
        li      a5,4
        ble     a4,a5,.L150
.L143:
        lw      a5,-32(s0)
        addi    a5,a5,1
        sw      a5,-32(s0)
.L138:
        lw      a4,-32(s0)
        li      a5,8192
        addi    a5,a5,-193
        ble     a4,a5,.L151
        li      a5,-1
        sw      a5,-48(s0)
        sw      zero,-52(s0)
        sw      zero,-56(s0)
        j       .L152
.L154:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-48(s0)
        bge     a4,a5,.L153
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-48(s0)
        lw      a5,-56(s0)
        sw      a5,-52(s0)
.L153:
        lw      a5,-56(s0)
        addi    a5,a5,1
        sw      a5,-56(s0)
.L152:
        lw      a4,-56(s0)
        li      a5,99
        ble     a4,a5,.L154
        lw      a5,-52(s0)
        mv      a0,a5
        lw      ra,76(sp)
        lw      s0,72(sp)
        lw      s1,68(sp)
        addi    sp,sp,80
        jr      ra
        .size   run_accelerator, .-run_accelerator
        .align  2
        .globl  main
        .type   main, @function
main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        sw      s1,20(sp)
        addi    s0,sp,32
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,2
        sw      a4,0(a5)
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,3
        sw      a4,4(a5)
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,3
        sw      a4,8(a5)
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,4
        sw      a4,12(a5)
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,5
        sw      a4,16(a5)
        lui     a5,%hi(my_positions)
        addi    a5,a5,%lo(my_positions)
        li      a4,-1
        sw      a4,0(a5)
        lui     a5,%hi(my_positions)
        addi    a5,a5,%lo(my_positions)
        li      a4,-1
        sw      a4,4(a5)
        lui     a5,%hi(my_positions)
        addi    a5,a5,%lo(my_positions)
        li      a4,-1
        sw      a4,8(a5)
        lui     a5,%hi(my_positions)
        addi    a5,a5,%lo(my_positions)
        li      a4,-1
        sw      a4,12(a5)
        lui     a5,%hi(my_positions)
        addi    a5,a5,%lo(my_positions)
        li      a4,-1
        sw      a4,16(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        sw      zero,0(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        sw      zero,4(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        sw      zero,8(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        sw      zero,12(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        sw      zero,16(a5)
        lui     a5,%hi(enemy_sunk)
        addi    a5,a5,%lo(enemy_sunk)
        li      a4,-1
        sw      a4,0(a5)
        lui     a5,%hi(enemy_sunk)
        addi    a5,a5,%lo(enemy_sunk)
        li      a4,-1
        sw      a4,4(a5)
        lui     a5,%hi(enemy_sunk)
        addi    a5,a5,%lo(enemy_sunk)
        li      a4,-1
        sw      a4,8(a5)
        lui     a5,%hi(enemy_sunk)
        addi    a5,a5,%lo(enemy_sunk)
        li      a4,-1
        sw      a4,12(a5)
        lui     a5,%hi(enemy_sunk)
        addi    a5,a5,%lo(enemy_sunk)
        li      a4,-1
        sw      a4,16(a5)
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        li      a0,12288
        call    send_ppu_value
        call    initialize_boards
        sw      zero,-20(s0)
        j       .L157
.L159:
        call    rand
        mv      a5,a0
        li      a1,100
        mv      a0,a5
        call    mod
        mv      s1,a0
        call    rand
        mv      a5,a0
        andi    a5,a5,1
        mv      a2,a5
        lw      a1,-20(s0)
        mv      a0,s1
        call    place_ship
        mv      a5,a0
        bne     a5,zero,.L158
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
.L158:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L157:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L159
        lui     a5,%hi(activeSquare)
        li      a4,55
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
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        lui     a5,%hi(ai_target)
        li      a4,55
        sw      a4,%lo(ai_target)(a5)
        lui     a5,%hi(old_ai_target)
        li      a4,55
        sw      a4,%lo(old_ai_target)(a5)
.L161:
        call    run_accelerator
        mv      a4,a0
        lui     a5,%hi(ai_target)
        sw      a4,%lo(ai_target)(a5)
        lui     a5,%hi(old_ai_target)
        lw      a5,%lo(old_ai_target)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        lui     a5,%hi(ai_target)
        lw      a5,%lo(ai_target)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,16384
        or      a5,a4,a5
        mv      a0,a5
        call    send_ppu_value
        lui     a5,%hi(ai_target)
        lw      a4,%lo(ai_target)(a5)
        lui     a5,%hi(old_ai_target)
        sw      a4,%lo(old_ai_target)(a5)
        lui     a5,%hi(accelerator_ran)
        li      a4,1
        sw      a4,%lo(accelerator_ran)(a5)
        nop
.L160:
        lui     a5,%hi(accelerator_ran)
        lw      a5,%lo(accelerator_ran)(a5)
        bne     a5,zero,.L160
        j       .L161
        .size   main, .-main
        .ident  "GCC: (g04696df09) 14.2.0"
        .section        .note.GNU-stack,"",@progbits