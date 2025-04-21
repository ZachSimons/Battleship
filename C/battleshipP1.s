        .file   "battleshipP1.c"
        .option nopic
        .attribute arch, "rv32i2p1"
        .attribute unaligned_access, 0
        .attribute stack_align, 16
        .text
        .globl  my_board
        .bss
        .align  2
        .type   my_board, @object
        .size   my_board, 400
my_board:
        .zero   400
        .globl  my_positions
        .align  2
        .type   my_positions, @object
        .size   my_positions, 20
my_positions:
        .zero   20
        .globl  target_board
        .align  2
        .type   target_board, @object
        .size   target_board, 100
target_board:
        .zero   100
        .globl  ship_sizes
        .section        .sbss,"aw",@nobits
        .align  2
        .type   ship_sizes, @object
        .size   ship_sizes, 5
ship_sizes:
        .zero   5
        .globl  my_sunk
        .bss
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
        .globl  active_square
        .section        .sbss
        .align  2
        .type   active_square, @object
        .size   active_square, 4
active_square:
        .zero   4
        .globl  toSnd
        .align  2
        .type   toSnd, @object
        .size   toSnd, 4
toSnd:
        .zero   4
        .globl  ai_target
        .align  2
        .type   ai_target, @object
        .size   ai_target, 4
ai_target:
        .zero   4
        .globl  enemy_result
        .align  2
        .type   enemy_result, @object
        .size   enemy_result, 4
enemy_result:
        .zero   4
        .globl  myTurn
        .align  2
        .type   myTurn, @object
        .size   myTurn, 4
myTurn:
        .zero   4
        .globl  possible_positions
        .bss
        .align  2
        .type   possible_positions, @object
        .size   possible_positions, 1000
possible_positions:
        .zero   1000
        .globl  hit_counts
        .align  2
        .type   hit_counts, @object
        .size   hit_counts, 400
hit_counts:
        .zero   400
        .text
        .align  2
        .globl  entry_point
        .type   entry_point, @function
entry_point:
 #APP
# 76 "battleshipP1.c" 1
        j main
# 0 "" 2
# 77 "battleshipP1.c" 1
        rdi a0
# 0 "" 2
# 78 "battleshipP1.c" 1
        call exception_handler
# 0 "" 2
# 79 "battleshipP1.c" 1
        rti
# 0 "" 2
 #NO_APP
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
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
        bgtu    a4,a5,.L3
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,2097152
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
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 86 "battleshipP1.c" 1
        lw a1,%lo(toSnd)(x0)
# 0 "" 2
# 87 "battleshipP1.c" 1
        snd a1
# 0 "" 2
 #NO_APP
        call    check_lose
        mv      a5,a0
        beq     a5,zero,.L4
 #APP
# 89 "battleshipP1.c" 1
        addi a0,zero,107
# 0 "" 2
# 90 "battleshipP1.c" 1
        snd a0
# 0 "" 2
# 91 "battleshipP1.c" 1
# 0 "" 2
 #NO_APP
        j       .L5
.L4:
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,4194304
        and     a5,a4,a5
        beq     a5,zero,.L6
        call    check_sinks
        mv      a5,a0
        beq     a5,zero,.L7
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        srai    a5,a5,17
        slli    a4,a5,20
        li      a5,7340032
        and     a5,a4,a5
        lui     a4,%hi(my_board)
        addi    a3,a4,%lo(my_board)
        lw      a4,-52(s0)
        slli    a4,a4,2
        add     a4,a3,a4
        lw      a4,0(a4)
        srai    a4,a4,17
        andi    a4,a4,7
        lui     a3,%hi(my_positions)
        addi    a3,a3,%lo(my_positions)
        slli    a4,a4,2
        add     a4,a3,a4
        lw      a4,0(a4)
        or      a4,a5,a4
        li      a5,-2147483648
        or      a5,a4,a5
        mv      a4,a5
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 95 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 96 "battleshipP1.c" 1
        snd a0
# 0 "" 2
 #NO_APP
        j       .L5
.L7:
 #APP
# 98 "battleshipP1.c" 1
        addi a0,zero,101
# 0 "" 2
# 99 "battleshipP1.c" 1
        snd a0
# 0 "" 2
 #NO_APP
        j       .L5
.L6:
 #APP
# 102 "battleshipP1.c" 1
        addi a0,zero,100
# 0 "" 2
# 103 "battleshipP1.c" 1
        snd a0
# 0 "" 2
 #NO_APP
.L5:
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        j       .L20
.L3:
        lw      a4,-52(s0)
        li      a5,100
        bne     a4,a5,.L9
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        li      a4,1
        sb      a4,0(a5)
 #APP
# 108 "battleshipP1.c" 1
        la a0,PRE_ACCELERATOR_LABEL
# 0 "" 2
# 109 "battleshipP1.c" 1
        rsi a0
# 0 "" 2
 #NO_APP
        j       .L20
.L9:
        lw      a4,-52(s0)
        li      a5,101
        bne     a4,a5,.L10
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        li      a4,2
        sb      a4,0(a5)
 #APP
# 112 "battleshipP1.c" 1
        la a0,PRE_ACCELERATOR_LABEL
# 0 "" 2
# 113 "battleshipP1.c" 1
        rsi a0
# 0 "" 2
 #NO_APP
        j       .L20
.L10:
        lw      a4,-52(s0)
        li      a5,102
        bne     a4,a5,.L11
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a5,a0
        beq     a5,zero,.L20
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a4,-8388608
        addi    a4,a4,-1
        and     a4,a3,a4
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 118 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 119 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        addi    a4,a5,-1
        lui     a5,%hi(active_square)
        sw      a4,%lo(active_square)(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a4,8388608
        or      a4,a3,a4
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 123 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 124 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        j       .L20
.L11:
        lw      a4,-52(s0)
        li      a5,103
        bne     a4,a5,.L12
        lui     a5,%hi(active_square)
        lw      a4,%lo(active_square)(a5)
        li      a5,9
        ble     a4,a5,.L20
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a4,-8388608
        addi    a4,a4,-1
        and     a4,a3,a4
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 130 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 131 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        addi    a4,a5,-10
        lui     a5,%hi(active_square)
        sw      a4,%lo(active_square)(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a4,8388608
        or      a4,a3,a4
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 135 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 136 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        j       .L20
.L12:
        lw      a4,-52(s0)
        li      a5,104
        bne     a4,a5,.L13
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a4,-8388608
        addi    a4,a4,-1
        and     a4,a3,a4
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 142 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 143 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        addi    a4,a5,10
        lui     a5,%hi(active_square)
        sw      a4,%lo(active_square)(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a4,8388608
        or      a4,a3,a4
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 147 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 148 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        j       .L20
.L13:
        lw      a4,-52(s0)
        li      a5,105
        bne     a4,a5,.L14
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a4,a0
        li      a5,9
        beq     a4,a5,.L20
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a4,-8388608
        addi    a4,a4,-1
        and     a4,a3,a4
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 154 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 155 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        addi    a4,a5,1
        lui     a5,%hi(active_square)
        sw      a4,%lo(active_square)(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a4,8388608
        or      a4,a3,a4
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 159 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(x0)
# 0 "" 2
# 160 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        j       .L20
.L14:
        lw      a4,-52(s0)
        li      a5,106
        bne     a4,a5,.L15
        lui     a5,%hi(myTurn)
        lw      a5,%lo(myTurn)(a5)
        beq     a5,zero,.L20
 #APP
# 164 "battleshipP1.c" 1
        lw a0,%lo(active_square)(x0)
# 0 "" 2
# 165 "battleshipP1.c" 1
        snd a0
# 0 "" 2
 #NO_APP
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        j       .L20
.L15:
        lw      a5,-52(s0)
        srli    a5,a5,8
        andi    a5,a5,255
        sw      a5,-24(s0)
        lw      a4,-24(s0)
        li      a5,99
        ble     a4,a5,.L16
        li      a5,10
        j       .L17
.L16:
        li      a5,1
.L17:
        sw      a5,-28(s0)
        li      a1,100
        lw      a0,-24(s0)
        call    mod
        sw      a0,-32(s0)
        lw      a5,-52(s0)
        srli    a5,a5,20
        andi    a5,a5,255
        sw      a5,-36(s0)
        sw      zero,-20(s0)
        j       .L18
.L19:
        lw      a1,-20(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-24(s0)
        add     a5,a4,a5
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        li      a4,3
        sb      a4,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L18:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-36(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a4,a5
        lw      a5,-20(s0)
        blt     a5,a4,.L19
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-36(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,-24(s0)
        sw      a4,0(a5)
 #APP
# 177 "battleshipP1.c" 1
        la a0,PRE_ACCELERATOR_LABEL
# 0 "" 2
# 178 "battleshipP1.c" 1
        rsi a0
# 0 "" 2
 #NO_APP
.L20:
        nop
        lw      ra,60(sp)
        lw      s0,56(sp)
        addi    sp,sp,64
        jr      ra
        .size   exception_handler, .-exception_handler
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
        j       .L22
.L23:
        lw      a4,-20(s0)
        lw      a5,-36(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L22:
        lw      a4,-24(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L23
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
        ble     a5,zero,.L30
        j       .L27
.L28:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        sub     a5,a4,a5
        sw      a5,-20(s0)
.L27:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        bgt     a4,a5,.L28
        j       .L29
.L31:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
.L30:
        lw      a5,-20(s0)
        blt     a5,zero,.L31
.L29:
        nop
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
# 204 "battleshipP1.c" 1
        ldr a0
# 0 "" 2
 #NO_APP
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   rand, .-rand
        .align  2
        .globl  clear_boards
        .type   clear_boards, @function
clear_boards:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L35
.L36:
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      zero,0(a5)
        lui     a5,%hi(target_board)
        addi    a4,a5,%lo(target_board)
        lw      a5,-20(s0)
        add     a5,a4,a5
        sb      zero,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L35:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L36
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   clear_boards, .-clear_boards
        .align  2
        .globl  place_ship
        .type   place_ship, @function
place_ship:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        sw      s1,36(sp)
        sw      s2,32(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      a2,-44(s0)
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-44(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        sw      a5,-28(s0)
        lw      a5,-40(s0)
        beq     a5,zero,.L38
        li      a5,10
        j       .L39
.L38:
        li      a5,1
.L39:
        sw      a5,-32(s0)
        lw      a5,-40(s0)
        beq     a5,zero,.L40
        lw      a5,-28(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L41
        li      a5,0
        j       .L42
.L40:
        li      a1,10
        lw      a0,-36(s0)
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
        ble     a4,a5,.L41
        li      a5,0
        j       .L42
.L41:
        sw      zero,-20(s0)
        j       .L43
.L45:
        lw      a1,-20(s0)
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a5,a4,a5
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,4194304
        and     a5,a4,a5
        beq     a5,zero,.L44
        li      a5,0
        j       .L42
.L44:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L43:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L45
        sw      zero,-24(s0)
        j       .L46
.L47:
        lw      a5,-44(s0)
        slli    a4,a5,17
        li      a5,917504
        and     a4,a4,a5
        li      a5,4194304
        or      a4,a4,a5
        lw      a5,-40(s0)
        slli    a3,a5,20
        li      a5,1048576
        and     a5,a3,a5
        or      s2,a4,a5
        lw      a5,-24(s0)
        slli    a4,a5,14
        li      a5,114688
        and     s1,a4,a5
        lw      a1,-24(s0)
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a5,a4,a5
        or      a4,s2,s1
        lui     a3,%hi(my_board)
        addi    a3,a3,%lo(my_board)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lw      a1,-24(s0)
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a5,a4,a5
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(toSnd)
        sw      a4,%lo(toSnd)(a5)
 #APP
# 235 "battleshipP1.c" 1
        lui     a0,%hi(toSnd)
        lw      a0,%lo(toSnd)(a0)
# 0 "" 2
# 236 "battleshipP1.c" 1
        ugs a0
# 0 "" 2
 #NO_APP
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L46:
        lw      a4,-24(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L47
        lw      a1,-40(s0)
        li      a0,100
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a4,a4,a5
        lui     a5,%hi(my_positions)
        addi    a3,a5,%lo(my_positions)
        lw      a5,-44(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        li      a5,1
.L42:
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        lw      s1,36(sp)
        lw      s2,32(sp)
        addi    sp,sp,48
        jr      ra
        .size   place_ship, .-place_ship
        .align  2
        .globl  check_lose
        .type   check_lose, @function
check_lose:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L49
.L52:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        bne     a4,a5,.L50
        li      a5,0
        j       .L51
.L50:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L49:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L52
        li      a5,1
.L51:
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   check_lose, .-check_lose
        .align  2
        .globl  clear_possible_positions
        .type   clear_possible_positions, @function
clear_possible_positions:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L54
.L59:
        sw      zero,-24(s0)
        j       .L55
.L58:
        sw      zero,-28(s0)
        j       .L56
.L57:
        li      a1,100
        lw      a0,-24(s0)
        call    mult
        mv      a4,a0
        lw      a5,-28(s0)
        add     a3,a4,a5
        lui     a5,%hi(possible_positions)
        addi    a2,a5,%lo(possible_positions)
        lw      a4,-20(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a2,a5
        add     a5,a5,a3
        sb      zero,0(a5)
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L56:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L57
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L55:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L58
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L54:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L59
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
        j       .L61
.L62:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      zero,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L61:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L62
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
        add     a5,a4,a5
        lbu     a5,0(a5)
        sw      a5,-24(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L65
        li      a5,10
        j       .L66
.L65:
        li      a5,1
.L66:
        sw      a5,-28(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L67
        lw      a5,-24(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L68
        li      a5,0
        j       .L69
.L67:
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
        ble     a4,a5,.L68
        li      a5,0
        j       .L69
.L68:
        sw      zero,-20(s0)
        j       .L70
.L73:
        lw      a1,-20(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a5,a4,a5
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        lbu     a4,0(a5)
        li      a5,1
        beq     a4,a5,.L71
        lw      a1,-20(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a5,a4,a5
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        lbu     a4,0(a5)
        li      a5,3
        bne     a4,a5,.L72
.L71:
        li      a5,0
        j       .L69
.L72:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L70:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        blt     a4,a5,.L73
        li      a5,1
.L69:
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
        j       .L75
.L82:
        lw      a5,-20(s0)
        lw      a4,-36(s0)
        add     a5,a4,a5
        lbu     a4,0(a5)
        li      a5,99
        bleu    a4,a5,.L76
        li      a5,10
        j       .L77
.L76:
        li      a5,1
.L77:
        sw      a5,-28(s0)
        lw      a5,-20(s0)
        lw      a4,-36(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        li      a1,100
        mv      a0,a5
        call    mod
        sw      a0,-32(s0)
        sw      zero,-24(s0)
        j       .L78
.L81:
        lw      a1,-24(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-32(s0)
        add     a5,a4,a5
        lw      a4,-40(s0)
        bne     a4,a5,.L79
        li      a5,1
        j       .L80
.L79:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L78:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a4,a5
        lw      a5,-24(s0)
        blt     a5,a4,.L81
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L75:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L82
        li      a5,0
.L80:
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
        add     a5,a4,a5
        lbu     a5,0(a5)
        sw      a5,-28(s0)
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-60(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        sw      a5,-32(s0)
        lw      a4,-56(s0)
        li      a5,99
        ble     a4,a5,.L84
        li      a5,10
        j       .L85
.L84:
        li      a5,1
.L85:
        sw      a5,-36(s0)
        lw      a4,-64(s0)
        li      a5,99
        ble     a4,a5,.L86
        li      a5,10
        j       .L87
.L86:
        li      a5,1
.L87:
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
        j       .L88
.L93:
        sw      zero,-24(s0)
        j       .L89
.L92:
        lw      a1,-36(s0)
        lw      a0,-20(s0)
        call    mult
        mv      a4,a0
        lw      a5,-44(s0)
        add     s1,a4,a5
        lw      a1,-40(s0)
        lw      a0,-24(s0)
        call    mult
        mv      a4,a0
        lw      a5,-48(s0)
        add     a5,a4,a5
        bne     s1,a5,.L90
        li      a5,0
        j       .L91
.L90:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L89:
        lw      a4,-24(s0)
        lw      a5,-32(s0)
        blt     a4,a5,.L92
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L88:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L93
        li      a5,1
.L91:
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
        j       .L95
.L98:
        lui     a5,%hi(target_board)
        addi    a4,a5,%lo(target_board)
        lw      a5,-20(s0)
        add     a5,a4,a5
        lbu     a4,0(a5)
        li      a5,2
        bne     a4,a5,.L96
        lw      a1,-20(s0)
        lw      a0,-36(s0)
        call    square_in_configuration
        mv      a5,a0
        bne     a5,zero,.L96
        li      a5,0
        j       .L97
.L96:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L95:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L98
        sw      zero,-24(s0)
        j       .L99
.L103:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
        j       .L100
.L102:
        lw      a5,-24(s0)
        lw      a4,-36(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a1,a5
        lw      a5,-28(s0)
        lw      a4,-36(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a3,a5
        lw      a2,-28(s0)
        lw      a0,-24(s0)
        call    calculate_overlap
        mv      a5,a0
        bne     a5,zero,.L101
        li      a5,0
        j       .L97
.L101:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L100:
        lw      a4,-28(s0)
        li      a5,4
        ble     a4,a5,.L102
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L99:
        lw      a4,-24(s0)
        li      a5,3
        ble     a4,a5,.L103
        li      a5,1
.L97:
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
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        sw      s1,52(sp)
        addi    s0,sp,64
        call    clear_accelerator_data
        sw      zero,-20(s0)
        j       .L105
.L113:
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        beq     a4,a5,.L106
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a3,0(a5)
        lui     a5,%hi(possible_positions)
        addi    a2,a5,%lo(possible_positions)
        lw      a4,-20(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a2,a5
        add     a5,a5,a3
        li      a4,1
        sb      a4,0(a5)
        j       .L107
.L106:
        sw      zero,-24(s0)
        j       .L108
.L112:
        sw      zero,-28(s0)
        j       .L109
.L111:
        lw      a2,-24(s0)
        lw      a1,-28(s0)
        lw      a0,-20(s0)
        call    check_valid_position
        mv      a5,a0
        beq     a5,zero,.L110
        li      a1,100
        lw      a0,-24(s0)
        call    mult
        mv      a4,a0
        lw      a5,-28(s0)
        add     a3,a4,a5
        lui     a5,%hi(possible_positions)
        addi    a2,a5,%lo(possible_positions)
        lw      a4,-20(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a2,a5
        add     a5,a5,a3
        li      a4,1
        sb      a4,0(a5)
.L110:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L109:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L111
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L108:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L112
.L107:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L105:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L113
        sw      zero,-32(s0)
        j       .L114
.L127:
        sw      zero,-36(s0)
        j       .L115
.L117:
        call    rand
        mv      a5,a0
        li      a1,200
        mv      a0,a5
        call    mod
        mv      a5,a0
        andi    a4,a5,255
        lw      a5,-36(s0)
        addi    a5,a5,-16
        add     a5,a5,s0
        sb      a4,-48(a5)
        lw      a5,-36(s0)
        addi    a5,a5,-16
        add     a5,a5,s0
        lbu     a5,-48(a5)
        mv      a2,a5
        lui     a5,%hi(possible_positions)
        addi    a3,a5,%lo(possible_positions)
        lw      a4,-36(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a5,a4
        slli    a5,a5,3
        add     a5,a3,a5
        add     a5,a5,a2
        lbu     a5,0(a5)
        bne     a5,zero,.L116
        lw      a5,-36(s0)
        addi    a5,a5,-1
        sw      a5,-36(s0)
.L116:
        lw      a5,-36(s0)
        addi    a5,a5,1
        sw      a5,-36(s0)
.L115:
        lw      a4,-36(s0)
        li      a5,4
        ble     a4,a5,.L117
        addi    a5,s0,-64
        mv      a0,a5
        call    check_valid_configuration
        mv      a5,a0
        bne     a5,zero,.L118
        lw      a5,-32(s0)
        addi    a5,a5,-1
        sw      a5,-32(s0)
        j       .L119
.L118:
        sw      zero,-40(s0)
        j       .L120
.L126:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-40(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        sb      a5,-57(s0)
        lw      a5,-40(s0)
        addi    a5,a5,-16
        add     a5,a5,s0
        lbu     a5,-48(a5)
        li      a1,100
        mv      a0,a5
        call    mod
        mv      a5,a0
        sb      a5,-58(s0)
        lw      a5,-40(s0)
        addi    a5,a5,-16
        add     a5,a5,s0
        lbu     a4,-48(a5)
        li      a5,99
        bleu    a4,a5,.L121
        li      a5,10
        j       .L122
.L121:
        li      a5,1
.L122:
        sb      a5,-59(s0)
        sw      zero,-44(s0)
        j       .L123
.L125:
        lbu     s1,-58(s0)
        lbu     a5,-59(s0)
        lw      a1,-44(s0)
        mv      a0,a5
        call    mult
        mv      a5,a0
        add     a5,s1,a5
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        lbu     a5,0(a5)
        bne     a5,zero,.L124
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
.L124:
        lw      a5,-44(s0)
        addi    a5,a5,1
        sw      a5,-44(s0)
.L123:
        lbu     a5,-57(s0)
        lw      a4,-44(s0)
        blt     a4,a5,.L125
        lw      a5,-40(s0)
        addi    a5,a5,1
        sw      a5,-40(s0)
.L120:
        lw      a4,-40(s0)
        li      a5,4
        ble     a4,a5,.L126
.L119:
        lw      a5,-32(s0)
        addi    a5,a5,1
        sw      a5,-32(s0)
.L114:
        lw      a4,-32(s0)
        li      a5,8192
        addi    a5,a5,-193
        ble     a4,a5,.L127
        li      a5,-1
        sw      a5,-48(s0)
        sw      zero,-52(s0)
        sw      zero,-56(s0)
        j       .L128
.L130:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-48(s0)
        bge     a4,a5,.L129
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-48(s0)
        lw      a5,-56(s0)
        sw      a5,-52(s0)
.L129:
        lw      a5,-56(s0)
        addi    a5,a5,1
        sw      a5,-56(s0)
.L128:
        lw      a4,-56(s0)
        li      a5,99
        ble     a4,a5,.L130
        lw      a5,-52(s0)
        mv      a0,a5
        lw      ra,60(sp)
        lw      s0,56(sp)
        lw      s1,52(sp)
        addi    sp,sp,64
        jr      ra
        .size   run_accelerator, .-run_accelerator
        .align  2
        .globl  check_sinks
        .type   check_sinks, @function
check_sinks:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      zero,-20(s0)
        j       .L133
.L141:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        bne     a4,a5,.L134
        li      a5,1
        sw      a5,-24(s0)
        lui     a5,%hi(my_positions)
        addi    a4,a5,%lo(my_positions)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,99
        ble     a4,a5,.L135
        li      a5,10
        j       .L136
.L135:
        li      a5,1
.L136:
        sw      a5,-32(s0)
        lui     a5,%hi(my_positions)
        addi    a4,a5,%lo(my_positions)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        li      a1,100
        mv      a0,a5
        call    mod
        sw      a0,-36(s0)
        sw      zero,-28(s0)
        j       .L137
.L139:
        lw      a1,-28(s0)
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a5,a4,a5
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,2097152
        and     a5,a4,a5
        bne     a5,zero,.L138
        sw      zero,-24(s0)
.L138:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L137:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a4,a5
        lw      a5,-28(s0)
        blt     a5,a4,.L139
        lw      a5,-24(s0)
        beq     a5,zero,.L134
        lui     a5,%hi(my_positions)
        addi    a4,a5,%lo(my_positions)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lui     a5,%hi(my_sunk)
        addi    a3,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        li      a5,1
        j       .L140
.L134:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L133:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L141
        li      a5,0
.L140:
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   check_sinks, .-check_sinks
        .align  2
        .globl  main
        .type   main, @function
main:
        lui     sp,1048575
        addi    sp,sp,4095
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        sw      s1,20(sp)
        addi    s0,sp,32
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,2
        sb      a4,0(a5)
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,3
        sb      a4,1(a5)
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,3
        sb      a4,2(a5)
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,4
        sb      a4,3(a5)
        lui     a5,%hi(ship_sizes)
        addi    a5,a5,%lo(ship_sizes)
        li      a4,5
        sb      a4,4(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        li      a4,-1
        sw      a4,0(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        li      a4,-1
        sw      a4,4(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        li      a4,-1
        sw      a4,8(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        li      a4,-1
        sw      a4,12(a5)
        lui     a5,%hi(my_sunk)
        addi    a5,a5,%lo(my_sunk)
        li      a4,-1
        sw      a4,16(a5)
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
        lui     a5,%hi(active_square)
        li      a4,55
        sw      a4,%lo(active_square)(a5)
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        call    clear_boards
        sw      zero,-20(s0)
        j       .L143
.L145:
        nop
.L144:
        call    rand
        mv      a5,a0
        li      a1,100
        mv      a0,a5
        call    mod
        mv      s1,a0
        call    rand
        mv      a5,a0
        li      a1,2
        mv      a0,a5
        call    mod
        mv      a5,a0
        lw      a2,-20(s0)
        mv      a1,a5
        mv      a0,s1
        call    place_ship
        mv      a5,a0
        beq     a5,zero,.L144
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L143:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L145
 #APP
# 441 "battleshipP1.c" 1
        PRE_ACCELERATOR_LABEL:
# 0 "" 2
 #NO_APP
        call    run_accelerator
        mv      a4,a0
        lui     a5,%hi(ai_target)
        sw      a4,%lo(ai_target)(a5)
 #APP
# 443 "battleshipP1.c" 1
# 0 "" 2
# 444 "battleshipP1.c" 1
        STALL_LOOP_LABEL:
# 0 "" 2
 #NO_APP
.L146:
        j       .L146
        .size   main, .-main
        .ident  "GCC: (g04696df09) 14.2.0"
        .section        .note.GNU-stack,"",@progbits