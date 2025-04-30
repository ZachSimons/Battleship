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
        .globl  configuration
        .align  2
        .type   configuration, @object
        .size   configuration, 20
configuration:
        .zero   20
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
        .globl  ai_ran
        .align  2
        .type   ai_ran, @object
        .size   ai_ran, 4
ai_ran:
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
# 33 "basic_test_code.c" 1
# 0 "" 2
# 34 "basic_test_code.c" 1
        rdi a0
# 0 "" 2
# 35 "basic_test_code.c" 1
        call exception_handler
# 0 "" 2
# 36 "basic_test_code.c" 1
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
        lui     a5,%hi(ai_ran)
        sw      zero,%lo(ai_ran)(a5)
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
        lui     a5,%hi(ai_ran)
        sw      zero,%lo(ai_ran)(a5)
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
        lui     a5,%hi(ai_ran)
        sw      zero,%lo(ai_ran)(a5)
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
# 157 "basic_test_code.c" 1
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
# 171 "basic_test_code.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 172 "basic_test_code.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 173 "basic_test_code.c" 1
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
# 178 "basic_test_code.c" 1
        lui a0,%hi(toSnd_board)
# 0 "" 2
# 179 "basic_test_code.c" 1
        lw a0,%lo(toSnd_board)(a0)
# 0 "" 2
# 180 "basic_test_code.c" 1
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
        beq     a4,a5,.L47
        lw      a4,-40(s0)
        li      a5,3
        bne     a4,a5,.L48
        lw      a4,-20(s0)
        li      a5,1048576
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L47
.L48:
        lw      a4,-40(s0)
        li      a5,4
        bne     a4,a5,.L49
        lw      a4,-20(s0)
        li      a5,2097152
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L47
.L49:
        lw      a4,-20(s0)
        li      a5,3145728
        or      a5,a4,a5
        sw      a5,-20(s0)
.L47:
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
        beq     a5,zero,.L52
        li      a5,10
        j       .L53
.L52:
        li      a5,1
.L53:
        sw      a5,-32(s0)
        lw      a5,-60(s0)
        beq     a5,zero,.L54
        lw      a5,-28(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L55
        li      a5,0
        j       .L56
.L54:
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
        ble     a4,a5,.L55
        li      a5,0
        j       .L56
.L55:
        sw      zero,-20(s0)
        j       .L57
.L59:
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
        bne     a4,a5,.L58
        li      a5,0
        j       .L56
.L58:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L57:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L59
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
        j       .L60
.L61:
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
.L60:
        lw      a4,-24(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L61
        li      a5,1
.L56:
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
        j       .L63
.L72:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        bne     a5,zero,.L64
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
        ble     a4,a5,.L65
        li      a5,10
        j       .L66
.L65:
        li      a5,1
.L66:
        sw      a5,-36(s0)
        li      a5,1
        sw      a5,-24(s0)
        sw      zero,-28(s0)
        j       .L67
.L70:
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
        beq     a4,a5,.L68
        sw      zero,-24(s0)
        j       .L69
.L68:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L67:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-28(s0)
        blt     a4,a5,.L70
.L69:
        lw      a5,-24(s0)
        beq     a5,zero,.L64
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        li      a4,1
        sw      a4,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        j       .L71
.L64:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L63:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L72
        li      a5,0
.L71:
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
        j       .L74
.L77:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        bne     a5,zero,.L75
        li      a5,0
        j       .L76
.L75:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L74:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L77
        li      a5,1
.L76:
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
        j       .L79
.L80:
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
.L79:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L80
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
        j       .L82
.L87:
        sw      zero,-24(s0)
        j       .L83
.L86:
        sw      zero,-28(s0)
        j       .L84
.L85:
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
.L84:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L85
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L83:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L86
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L82:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L87
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
        j       .L89
.L90:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      zero,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L89:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L90
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
        beq     a5,zero,.L93
        li      a5,10
        j       .L94
.L93:
        li      a5,1
.L94:
        sw      a5,-28(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L95
        lw      a5,-24(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L96
        li      a5,0
        j       .L97
.L95:
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
        ble     a4,a5,.L96
        li      a5,0
        j       .L97
.L96:
        sw      zero,-20(s0)
        j       .L98
.L101:
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
        beq     a4,a5,.L99
        lw      a4,-32(s0)
        li      a5,12582912
        bne     a4,a5,.L100
.L99:
        li      a5,0
        j       .L97
.L100:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L98:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        blt     a4,a5,.L101
        li      a5,1
.L97:
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
        sw      zero,-20(s0)
        j       .L103
.L110:
        lui     a5,%hi(configuration)
        addi    a4,a5,%lo(configuration)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,99
        ble     a4,a5,.L104
        li      a5,10
        j       .L105
.L104:
        li      a5,1
.L105:
        sw      a5,-28(s0)
        lui     a5,%hi(configuration)
        addi    a4,a5,%lo(configuration)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        li      a1,100
        mv      a0,a5
        call    mod
        sw      a0,-32(s0)
        sw      zero,-24(s0)
        j       .L106
.L109:
        lw      a1,-24(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-32(s0)
        add     a5,a4,a5
        lw      a4,-36(s0)
        bne     a4,a5,.L107
        li      a5,1
        j       .L108
.L107:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L106:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-24(s0)
        blt     a4,a5,.L109
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L103:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L110
        li      a5,0
.L108:
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
        ble     a4,a5,.L112
        li      a5,10
        j       .L113
.L112:
        li      a5,1
.L113:
        sw      a5,-36(s0)
        lw      a4,-64(s0)
        li      a5,99
        ble     a4,a5,.L114
        li      a5,10
        j       .L115
.L114:
        li      a5,1
.L115:
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
        j       .L116
.L121:
        sw      zero,-24(s0)
        j       .L117
.L120:
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
        bne     s1,a5,.L118
        li      a5,0
        j       .L119
.L118:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L117:
        lw      a4,-24(s0)
        lw      a5,-32(s0)
        blt     a4,a5,.L120
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L116:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L121
        li      a5,1
.L119:
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
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L123
.L126:
        lui     a5,%hi(board)
        addi    a4,a5,%lo(board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,8388608
        bne     a4,a5,.L124
        lw      a0,-20(s0)
        call    square_in_configuration
        mv      a5,a0
        bne     a5,zero,.L124
        li      a5,0
        j       .L125
.L124:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L123:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L126
        sw      zero,-24(s0)
        j       .L127
.L131:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
        j       .L128
.L130:
        lui     a5,%hi(configuration)
        addi    a4,a5,%lo(configuration)
        lw      a5,-24(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a1,0(a5)
        lui     a5,%hi(configuration)
        addi    a4,a5,%lo(configuration)
        lw      a5,-28(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a3,a5
        lw      a2,-28(s0)
        lw      a0,-24(s0)
        call    calculate_overlap
        mv      a5,a0
        bne     a5,zero,.L129
        li      a5,0
        j       .L125
.L129:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L128:
        lw      a4,-28(s0)
        li      a5,4
        ble     a4,a5,.L130
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L127:
        lw      a4,-24(s0)
        li      a5,3
        ble     a4,a5,.L131
        li      a5,1
.L125:
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   check_valid_configuration, .-check_valid_configuration
        .align  2
        .globl  run_accelerator
        .type   run_accelerator, @function
run_accelerator:
        addi    sp,sp,-80
        sw      ra,76(sp)
        sw      s0,72(sp)
        addi    s0,sp,80
        call    clear_accelerator_data
        sw      zero,-20(s0)
        j       .L133
.L141:
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        beq     a4,a5,.L134
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
        j       .L135
.L134:
        sw      zero,-24(s0)
        j       .L136
.L140:
        sw      zero,-28(s0)
        j       .L137
.L139:
        lw      a2,-24(s0)
        lw      a1,-28(s0)
        lw      a0,-20(s0)
        call    check_valid_position
        mv      a5,a0
        beq     a5,zero,.L138
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
.L138:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L137:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L139
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L136:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L140
.L135:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L133:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L141
        sw      zero,-32(s0)
        j       .L142
.L155:
        sw      zero,-36(s0)
        j       .L143
.L145:
        call    rand
        mv      a5,a0
        li      a1,200
        mv      a0,a5
        call    mod
        mv      a3,a0
        lui     a5,%hi(configuration)
        addi    a4,a5,%lo(configuration)
        lw      a5,-36(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      a3,0(a5)
        lui     a5,%hi(configuration)
        addi    a4,a5,%lo(configuration)
        lw      a5,-36(s0)
        slli    a5,a5,2
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
        bne     a5,zero,.L144
        lw      a5,-36(s0)
        addi    a5,a5,-1
        sw      a5,-36(s0)
.L144:
        lw      a5,-36(s0)
        addi    a5,a5,1
        sw      a5,-36(s0)
.L143:
        lw      a4,-36(s0)
        li      a5,4
        ble     a4,a5,.L145
        call    check_valid_configuration
        mv      a5,a0
        bne     a5,zero,.L146
        lw      a5,-32(s0)
        addi    a5,a5,-1
        sw      a5,-32(s0)
        j       .L147
.L146:
        sw      zero,-40(s0)
        j       .L148
.L154:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-40(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-60(s0)
        lui     a5,%hi(configuration)
        addi    a4,a5,%lo(configuration)
        lw      a5,-40(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        li      a1,100
        mv      a0,a5
        call    mod
        sw      a0,-64(s0)
        lui     a5,%hi(configuration)
        addi    a4,a5,%lo(configuration)
        lw      a5,-40(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,99
        ble     a4,a5,.L149
        li      a5,10
        j       .L150
.L149:
        li      a5,1
.L150:
        sw      a5,-68(s0)
        sw      zero,-44(s0)
        j       .L151
.L153:
        lw      a1,-44(s0)
        lw      a0,-68(s0)
        call    mult
        mv      a4,a0
        lw      a5,-64(s0)
        add     a5,a4,a5
        lui     a4,%hi(board)
        addi    a4,a4,%lo(board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a5,a4,a5
        bne     a5,zero,.L152
        lw      a1,-44(s0)
        lw      a0,-68(s0)
        call    mult
        mv      a4,a0
        lw      a5,-64(s0)
        add     a5,a4,a5
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
.L152:
        lw      a5,-44(s0)
        addi    a5,a5,1
        sw      a5,-44(s0)
.L151:
        lw      a4,-44(s0)
        lw      a5,-60(s0)
        blt     a4,a5,.L153
        lw      a5,-40(s0)
        addi    a5,a5,1
        sw      a5,-40(s0)
.L148:
        lw      a4,-40(s0)
        li      a5,4
        ble     a4,a5,.L154
.L147:
        lw      a5,-32(s0)
        addi    a5,a5,1
        sw      a5,-32(s0)
.L142:
        lw      a4,-32(s0)
        li      a5,999
        ble     a4,a5,.L155
        li      a5,-1
        sw      a5,-48(s0)
        sw      zero,-52(s0)
        sw      zero,-56(s0)
        j       .L156
.L158:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-48(s0)
        bge     a4,a5,.L157
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-48(s0)
        lw      a5,-56(s0)
        sw      a5,-52(s0)
.L157:
        lw      a5,-56(s0)
        addi    a5,a5,1
        sw      a5,-56(s0)
.L156:
        lw      a4,-56(s0)
        li      a5,99
        ble     a4,a5,.L158
        lw      a5,-52(s0)
        mv      a0,a5
        lw      ra,76(sp)
        lw      s0,72(sp)
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
        j       .L161
.L163:
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
        bne     a5,zero,.L162
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
.L162:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L161:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L163
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
        lui     a5,%hi(ai_ran)
        sw      zero,%lo(ai_ran)(a5)
.L167:
        call    run_accelerator
        mv      a4,a0
        lui     a5,%hi(ai_target)
        sw      a4,%lo(ai_target)(a5)
        lui     a5,%hi(ai_ran)
        li      a4,1
        sw      a4,%lo(ai_ran)(a5)
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
        bne     a5,zero,.L164
        li      a5,16384
        j       .L165
.L164:
        li      a5,0
.L165:
        or      a5,a5,a4
        mv      a0,a5
        call    send_ppu_value
        nop
.L166:
        lui     a5,%hi(ai_ran)
        lw      a5,%lo(ai_ran)(a5)
        bne     a5,zero,.L166
        j       .L167
        j       .L167
        j       .L167
        j       .L167
        j       .L167
        .size   main, .-main
        .ident  "GCC: (g04696df09) 14.2.0"
        .section        .note.GNU-stack,"",@progbits