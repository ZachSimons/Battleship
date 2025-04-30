        .file   "basic_test_code_acc.c"
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
        .globl  toSnd_board
        .align  2
        .type   toSnd_board, @object
        .size   toSnd_board, 4
toSnd_board:
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
        .globl  ai_old_target
        .align  2
        .type   ai_old_target, @object
        .size   ai_old_target, 4
ai_old_target:
        .zero   4
        .globl  acc_result
        .align  2
        .type   acc_result, @object
        .size   acc_result, 4
acc_result:
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
# 35 "basic_test_code_acc.c" 1
# 0 "" 2
# 36 "basic_test_code_acc.c" 1
        rdi a0
# 0 "" 2
# 37 "basic_test_code_acc.c" 1
        call exception_handler
# 0 "" 2
# 38 "basic_test_code_acc.c" 1
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
        j       .L28
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
        j       .L28
.L5:
        li      a0,101
        call    send_board_value
        li      a0,12288
        call    send_ppu_value
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        j       .L28
.L4:
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a5,a4,a5
        bne     a5,zero,.L8
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
        j       .L28
.L8:
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,4194304
        bne     a4,a5,.L9
        li      a0,100
        call    send_board_value
        li      a0,12288
        call    send_ppu_value
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        j       .L28
.L9:
        li      a0,101
        call    send_board_value
        li      a0,12288
        call    send_ppu_value
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        j       .L28
.L3:
        lw      a4,-52(s0)
        li      a5,100
        bne     a4,a5,.L10
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        li      a0,8192
        call    send_ppu_value
        lui     a5,%hi(ai_target)
        lw      a5,%lo(ai_target)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
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
        j       .L28
.L10:
        lw      a4,-52(s0)
        li      a5,101
        bne     a4,a5,.L11
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        li      a0,8192
        call    send_ppu_value
        lui     a5,%hi(ai_target)
        lw      a5,%lo(ai_target)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
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
        j       .L28
.L11:
        lw      a4,-52(s0)
        li      a5,106
        bgt     a4,a5,.L12
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
        lui     a5,%hi(activeSquare)
        lw      a3,%lo(activeSquare)(a5)
        lui     a5,%hi(ai_target)
        lw      a5,%lo(ai_target)(a5)
        bne     a3,a5,.L13
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a3,0(a5)
        li      a5,12582912
        and     a5,a3,a5
        bne     a5,zero,.L13
        li      a5,16384
        j       .L14
.L13:
        li      a5,0
.L14:
        or      a5,a5,a4
        mv      a0,a5
        call    send_ppu_value
        lw      a4,-52(s0)
        li      a5,102
        bne     a4,a5,.L15
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a5,a0
        beq     a5,zero,.L16
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,-1
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L16
.L15:
        lw      a4,-52(s0)
        li      a5,103
        bne     a4,a5,.L17
        lui     a5,%hi(activeSquare)
        lw      a4,%lo(activeSquare)(a5)
        li      a5,9
        ble     a4,a5,.L16
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,-10
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L16
.L17:
        lw      a4,-52(s0)
        li      a5,104
        bne     a4,a5,.L18
        lui     a5,%hi(activeSquare)
        lw      a4,%lo(activeSquare)(a5)
        li      a5,89
        bgt     a4,a5,.L16
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,10
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L16
.L18:
        lw      a4,-52(s0)
        li      a5,105
        bne     a4,a5,.L19
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a4,a0
        li      a5,8
        bgt     a4,a5,.L16
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,1
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L16
.L19:
        lw      a4,-52(s0)
        li      a5,106
        bne     a4,a5,.L16
        lui     a5,%hi(myTurn)
        lw      a5,%lo(myTurn)(a5)
        beq     a5,zero,.L16
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a5,a4,a5
        bne     a5,zero,.L16
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        mv      a0,a5
        call    send_board_value
.L16:
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
        bne     a3,a5,.L20
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a3,0(a5)
        li      a5,12582912
        and     a5,a3,a5
        bne     a5,zero,.L20
        li      a5,16384
        j       .L21
.L20:
        li      a5,0
.L21:
        or      a5,a5,a4
        mv      a0,a5
        call    send_ppu_value
        j       .L28
.L12:
        lw      a4,-52(s0)
        li      a5,107
        bne     a4,a5,.L22
        lui     a5,%hi(toSnd_board)
        lw      a5,%lo(toSnd_board)(a5)
        mv      a0,a5
        call    send_board_value
        j       .L28
.L22:
        lw      a4,-52(s0)
        li      a5,262144
        bge     a4,a5,.L23
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        li      a0,8192
        call    send_ppu_value
        lui     a5,%hi(ai_target)
        lw      a5,%lo(ai_target)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
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
        ble     a4,a5,.L24
        li      a5,10
        j       .L25
.L24:
        li      a5,1
.L25:
        sw      a5,-36(s0)
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-24(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,-28(s0)
        sw      a4,0(a5)
        sw      zero,-20(s0)
        j       .L26
.L27:
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
.L26:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-24(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-20(s0)
        blt     a4,a5,.L27
        lw      a4,-52(s0)
        li      a5,131072
        and     a5,a4,a5
        beq     a5,zero,.L28
        li      a5,4096
        addi    a0,a5,-1024
        call    send_ppu_value
        j       .L28
.L23:
        li      a0,107
        call    send_board_value
.L28:
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
        ble     a5,zero,.L34
        j       .L31
.L32:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        sub     a5,a4,a5
        sw      a5,-20(s0)
.L31:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        bge     a4,a5,.L32
        j       .L33
.L35:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
.L34:
        lw      a5,-20(s0)
        blt     a5,zero,.L35
.L33:
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
# 156 "basic_test_code_acc.c" 1
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
        j       .L40
.L41:
        lw      a4,-20(s0)
        lw      a5,-36(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L40:
        lw      a4,-24(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L41
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
# 170 "basic_test_code_acc.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 171 "basic_test_code_acc.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 172 "basic_test_code_acc.c" 1
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
        lui     a5,%hi(toSnd_board)
        lw      a4,-20(s0)
        sw      a4,%lo(toSnd_board)(a5)
 #APP
# 177 "basic_test_code_acc.c" 1
        lui a0,%hi(toSnd_board)
# 0 "" 2
# 178 "basic_test_code_acc.c" 1
        lw a0,%lo(toSnd_board)(a0)
# 0 "" 2
# 179 "basic_test_code_acc.c" 1
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
        .globl  send_accel_value
        .type   send_accel_value, @function
send_accel_value:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        lui     a5,%hi(toSnd)
        lw      a4,-20(s0)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 184 "basic_test_code_acc.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 185 "basic_test_code_acc.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 186 "basic_test_code_acc.c" 1
        uad a0
# 0 "" 2
 #NO_APP
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   send_accel_value, .-send_accel_value
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
        beq     a4,a5,.L48
        lw      a4,-40(s0)
        li      a5,3
        bne     a4,a5,.L49
        lw      a4,-20(s0)
        li      a5,1048576
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L48
.L49:
        lw      a4,-40(s0)
        li      a5,4
        bne     a4,a5,.L50
        lw      a4,-20(s0)
        li      a5,2097152
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L48
.L50:
        lw      a4,-20(s0)
        li      a5,3145728
        or      a5,a4,a5
        sw      a5,-20(s0)
.L48:
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
        .globl  generate_acc_encoding
        .type   generate_acc_encoding, @function
generate_acc_encoding:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      a2,-44(s0)
        sw      a3,-48(s0)
        sw      zero,-20(s0)
        li      a1,100
        lw      a0,-40(s0)
        call    mod
        mv      a5,a0
        slli    a4,a5,25
        lw      a3,-40(s0)
        li      a5,99
        ble     a3,a5,.L53
        li      a5,16777216
        j       .L54
.L53:
        li      a5,0
.L54:
        or      a4,a5,a4
        lw      a5,-36(s0)
        slli    a5,a5,21
        or      a5,a4,a5
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        li      a1,100
        lw      a0,-48(s0)
        call    mod
        mv      a5,a0
        slli    a4,a5,14
        lw      a3,-48(s0)
        li      a5,99
        ble     a3,a5,.L55
        li      a5,8192
        j       .L56
.L55:
        li      a5,0
.L56:
        or      a4,a5,a4
        lw      a5,-44(s0)
        slli    a5,a5,10
        or      a5,a4,a5
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-20(s0)
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   generate_acc_encoding, .-generate_acc_encoding
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
        beq     a5,zero,.L59
        li      a5,10
        j       .L60
.L59:
        li      a5,1
.L60:
        sw      a5,-32(s0)
        lw      a5,-60(s0)
        beq     a5,zero,.L61
        lw      a5,-28(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L62
        li      a5,0
        j       .L63
.L61:
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
        ble     a4,a5,.L62
        li      a5,0
        j       .L63
.L62:
        sw      zero,-20(s0)
        j       .L64
.L66:
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
        bne     a4,a5,.L65
        li      a5,0
        j       .L63
.L65:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L64:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L66
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
        j       .L67
.L68:
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
.L67:
        lw      a4,-24(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L68
        li      a5,1
.L63:
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
        j       .L70
.L79:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        bne     a5,zero,.L71
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
        ble     a4,a5,.L72
        li      a5,10
        j       .L73
.L72:
        li      a5,1
.L73:
        sw      a5,-36(s0)
        li      a5,1
        sw      a5,-24(s0)
        sw      zero,-28(s0)
        j       .L74
.L77:
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
        beq     a4,a5,.L75
        sw      zero,-24(s0)
        j       .L76
.L75:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L74:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-28(s0)
        blt     a4,a5,.L77
.L76:
        lw      a5,-24(s0)
        beq     a5,zero,.L71
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        li      a4,1
        sw      a4,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        j       .L78
.L71:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L70:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L79
        li      a5,0
.L78:
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
        j       .L81
.L84:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        bne     a5,zero,.L82
        li      a5,0
        j       .L83
.L82:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L81:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L84
        li      a5,1
.L83:
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   check_lose, .-check_lose
        .align  2
        .globl  initialize_boards
        .type   initialize_boards, @function
initialize_boards:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L86
.L87:
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
.L86:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L87
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
        j       .L89
.L94:
        sw      zero,-24(s0)
        j       .L90
.L93:
        sw      zero,-28(s0)
        j       .L91
.L92:
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
.L91:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L92
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L90:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L93
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L89:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L94
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
        j       .L96
.L97:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      zero,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L96:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L97
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
        beq     a5,zero,.L100
        li      a5,10
        j       .L101
.L100:
        li      a5,1
.L101:
        sw      a5,-28(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L102
        lw      a5,-24(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L103
        li      a5,0
        j       .L104
.L102:
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
        ble     a4,a5,.L103
        li      a5,0
        j       .L104
.L103:
        sw      zero,-20(s0)
        j       .L105
.L108:
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
        beq     a4,a5,.L106
        lw      a4,-32(s0)
        li      a5,12582912
        bne     a4,a5,.L107
.L106:
        li      a5,0
        j       .L104
.L107:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L105:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        blt     a4,a5,.L108
        li      a5,1
.L104:
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
        j       .L110
.L117:
        lw      a5,-20(s0)
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,99
        ble     a4,a5,.L111
        li      a5,10
        j       .L112
.L111:
        li      a5,1
.L112:
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
        j       .L113
.L116:
        lw      a1,-24(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-32(s0)
        add     a5,a4,a5
        lw      a4,-40(s0)
        bne     a4,a5,.L114
        li      a5,1
        j       .L115
.L114:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L113:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-24(s0)
        blt     a4,a5,.L116
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L110:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L117
        li      a5,0
.L115:
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
        ble     a4,a5,.L119
        li      a5,10
        j       .L120
.L119:
        li      a5,1
.L120:
        sw      a5,-36(s0)
        lw      a4,-64(s0)
        li      a5,99
        ble     a4,a5,.L121
        li      a5,10
        j       .L122
.L121:
        li      a5,1
.L122:
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
        j       .L123
.L128:
        sw      zero,-24(s0)
        j       .L124
.L127:
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
        bne     s1,a5,.L125
        li      a5,0
        j       .L126
.L125:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L124:
        lw      a4,-24(s0)
        lw      a5,-32(s0)
        blt     a4,a5,.L127
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L123:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L128
        li      a5,1
.L126:
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
        j       .L130
.L133:
        lui     a5,%hi(board)
        addi    a4,a5,%lo(board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,8388608
        bne     a4,a5,.L131
        lw      a1,-20(s0)
        lw      a0,-36(s0)
        call    square_in_configuration
        mv      a5,a0
        bne     a5,zero,.L131
        li      a5,0
        j       .L132
.L131:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L130:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L133
        lw      a5,-36(s0)
        lw      a4,0(a5)
        lw      a5,-36(s0)
        addi    a5,a5,4
        lw      a5,0(a5)
        mv      a3,a5
        li      a2,1
        mv      a1,a4
        li      a0,0
        call    generate_acc_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_accel_value
        lw      a5,-36(s0)
        addi    a5,a5,8
        lw      a4,0(a5)
        lw      a5,-36(s0)
        addi    a5,a5,12
        lw      a5,0(a5)
        mv      a3,a5
        li      a2,3
        mv      a1,a4
        li      a0,2
        call    generate_acc_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_accel_value
        lw      a5,-36(s0)
        addi    a5,a5,16
        lw      a5,0(a5)
        li      a3,5
        li      a2,5
        mv      a1,a5
        li      a0,4
        call    generate_acc_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_accel_value
 #APP
# 361 "basic_test_code_acc.c" 1
        sac a1
# 0 "" 2
# 362 "basic_test_code_acc.c" 1
        lui a5,%hi(acc_result)
# 0 "" 2
# 363 "basic_test_code_acc.c" 1
        sw a1,%lo(acc_result)(a5)
# 0 "" 2
 #NO_APP
        lui     a5,%hi(acc_result)
        lw      a5,%lo(acc_result)(a5)
.L132:
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
        j       .L135
.L143:
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        beq     a4,a5,.L136
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
        j       .L137
.L136:
        sw      zero,-24(s0)
        j       .L138
.L142:
        sw      zero,-28(s0)
        j       .L139
.L141:
        lw      a2,-24(s0)
        lw      a1,-28(s0)
        lw      a0,-20(s0)
        call    check_valid_position
        mv      a5,a0
        beq     a5,zero,.L140
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
.L140:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L139:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L141
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L138:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L142
.L137:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L135:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L143
        sw      zero,-32(s0)
        j       .L144
.L157:
        sw      zero,-36(s0)
        j       .L145
.L147:
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
        bne     a5,zero,.L146
        lw      a5,-36(s0)
        addi    a5,a5,-1
        sw      a5,-36(s0)
.L146:
        lw      a5,-36(s0)
        addi    a5,a5,1
        sw      a5,-36(s0)
.L145:
        lw      a4,-36(s0)
        li      a5,4
        ble     a4,a5,.L147
        addi    a5,s0,-80
        mv      a0,a5
        call    check_valid_configuration
        mv      a5,a0
        bne     a5,zero,.L148
        lw      a5,-32(s0)
        addi    a5,a5,-1
        sw      a5,-32(s0)
        j       .L149
.L148:
        sw      zero,-40(s0)
        j       .L150
.L156:
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
        ble     a4,a5,.L151
        li      a5,10
        j       .L152
.L151:
        li      a5,1
.L152:
        sb      a5,-59(s0)
        sw      zero,-44(s0)
        j       .L153
.L155:
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
        bne     a5,zero,.L154
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
.L154:
        lw      a5,-44(s0)
        addi    a5,a5,1
        sw      a5,-44(s0)
.L153:
        lbu     a5,-57(s0)
        lw      a4,-44(s0)
        blt     a4,a5,.L155
        lw      a5,-40(s0)
        addi    a5,a5,1
        sw      a5,-40(s0)
.L150:
        lw      a4,-40(s0)
        li      a5,4
        ble     a4,a5,.L156
.L149:
        lw      a5,-32(s0)
        addi    a5,a5,1
        sw      a5,-32(s0)
.L144:
        lw      a4,-32(s0)
        li      a5,999
        ble     a4,a5,.L157
        li      a5,-1
        sw      a5,-48(s0)
        sw      zero,-52(s0)
        sw      zero,-56(s0)
        j       .L158
.L160:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-48(s0)
        bge     a4,a5,.L159
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-48(s0)
        lw      a5,-56(s0)
        sw      a5,-52(s0)
.L159:
        lw      a5,-56(s0)
        addi    a5,a5,1
        sw      a5,-56(s0)
.L158:
        lw      a4,-56(s0)
        li      a5,99
        ble     a4,a5,.L160
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
        j       .L163
.L165:
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
        bne     a5,zero,.L164
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
.L164:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L163:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L165
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
        lui     a5,%hi(ai_old_target)
        li      a4,55
        sw      a4,%lo(ai_old_target)(a5)
        lui     a5,%hi(acc_result)
        sw      zero,%lo(acc_result)(a5)
.L168:
        call    run_accelerator
        mv      a4,a0
        lui     a5,%hi(ai_target)
        sw      a4,%lo(ai_target)(a5)
        lui     a5,%hi(ai_old_target)
        lw      a5,%lo(ai_old_target)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        lui     a5,%hi(ai_target)
        lw      a4,%lo(ai_target)(a5)
        lui     a5,%hi(ai_old_target)
        sw      a4,%lo(ai_old_target)(a5)
        lui     a5,%hi(ai_target)
        lw      a5,%lo(ai_target)(a5)
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(ai_target)
        lw      a5,%lo(ai_target)(a5)
        lui     a3,%hi(board)
        addi    a3,a3,%lo(board)
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a3,0(a5)
        li      a5,12582912
        and     a5,a3,a5
        bne     a5,zero,.L166
        li      a5,16384
        j       .L167
.L166:
        li      a5,0
.L167:
        or      a5,a5,a4
        mv      a0,a5
        call    send_ppu_value
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        j       .L168
        .size   main, .-main
        .ident  "GCC: (g04696df09) 14.2.0"
        .section        .note.GNU-stack,"",@progbits