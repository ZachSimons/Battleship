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
        .globl  shot_square
        .align  2
        .type   shot_square, @object
        .size   shot_square, 4
shot_square:
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
        j main
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        sw      a0,4(sp)
        addi    s0,sp,16
 #APP
# 90 "battleshipP1.c" 1
# 0 "" 2
# 91 "battleshipP1.c" 1
        rdi a0
# 0 "" 2
# 92 "battleshipP1.c" 1
        call exception_handler
# 0 "" 2
# 93 "battleshipP1.c" 1
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
        lw      a5,0(a5)
        mv      a0,a5
        call    convert_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_ppu_value
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,4194304
        and     a5,a4,a5
        beq     a5,zero,.L4
        call    check_sinks
        mv      a5,a0
        beq     a5,zero,.L5
        call    check_lose
        mv      a5,a0
        beq     a5,zero,.L6
        li      a0,107
        call    send_board_value
        call    reset_program
        j       .L7
.L6:
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        srai    a5,a5,17
        slli    a4,a5,16
        li      a5,458752
        and     a4,a4,a5
        li      a5,8388608
        or      a4,a4,a5
        lui     a5,%hi(my_board)
        addi    a3,a5,%lo(my_board)
        lw      a5,-52(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a5,0(a5)
        srai    a5,a5,17
        andi    a5,a5,7
        lui     a3,%hi(my_positions)
        addi    a3,a3,%lo(my_positions)
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a5,0(a5)
        slli    a5,a5,8
        slli    a5,a5,16
        srli    a5,a5,16
        or      a5,a4,a5
        mv      a0,a5
        call    send_board_value
        j       .L7
.L5:
        li      a0,101
        call    send_board_value
        j       .L7
.L4:
        li      a0,100
        call    send_board_value
.L7:
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        j       .L23
.L3:
        lw      a4,-52(s0)
        li      a5,107
        bne     a4,a5,.L9
        call    reset_program
        j       .L23
.L9:
        lw      a4,-52(s0)
        li      a5,100
        bne     a4,a5,.L10
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        lui     a5,%hi(shot_square)
        lw      a5,%lo(shot_square)(a5)
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        li      a4,1
        sb      a4,0(a5)
        lui     a5,%hi(shot_square)
        lw      a5,%lo(shot_square)(a5)
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a0,a5
        lui     a5,%hi(shot_square)
        lw      a3,%lo(shot_square)(a5)
        lui     a5,%hi(active_square)
        lw      a4,%lo(active_square)(a5)
        lui     a5,%hi(shot_square)
        lw      a5,%lo(shot_square)(a5)
        sub     a5,a4,a5
        seqz    a5,a5
        andi    a5,a5,255
        mv      a2,a5
        mv      a1,a3
        call    target_to_ppu_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_ppu_value
        call    rsi_inst
        j       .L23
.L10:
        lw      a4,-52(s0)
        li      a5,101
        bne     a4,a5,.L11
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        lui     a5,%hi(shot_square)
        lw      a5,%lo(shot_square)(a5)
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        li      a4,2
        sb      a4,0(a5)
        lui     a5,%hi(shot_square)
        lw      a5,%lo(shot_square)(a5)
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a0,a5
        lui     a5,%hi(shot_square)
        lw      a3,%lo(shot_square)(a5)
        lui     a5,%hi(active_square)
        lw      a4,%lo(active_square)(a5)
        lui     a5,%hi(shot_square)
        lw      a5,%lo(shot_square)(a5)
        sub     a5,a4,a5
        seqz    a5,a5
        andi    a5,a5,255
        mv      a2,a5
        mv      a1,a3
        call    target_to_ppu_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_ppu_value
        call    rsi_inst
        j       .L23
.L11:
        lw      a4,-52(s0)
        li      a5,106
        bgtu    a4,a5,.L12
        lw      a4,-52(s0)
        li      a5,106
        bne     a4,a5,.L13
        lui     a5,%hi(myTurn)
        lw      a5,%lo(myTurn)(a5)
        beq     a5,zero,.L23
        lui     a5,%hi(active_square)
        lw      a4,%lo(active_square)(a5)
        lui     a5,%hi(shot_square)
        sw      a4,%lo(shot_square)(a5)
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        mv      a0,a5
        call    send_board_value
        j       .L23
.L13:
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a4,a5
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a2,0
        mv      a1,a5
        mv      a0,a4
        call    target_to_ppu_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_ppu_value
        lw      a4,-52(s0)
        li      a5,102
        bne     a4,a5,.L14
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a5,a0
        beq     a5,zero,.L14
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        addi    a4,a5,-1
        lui     a5,%hi(active_square)
        sw      a4,%lo(active_square)(a5)
        j       .L15
.L14:
        lw      a4,-52(s0)
        li      a5,103
        bne     a4,a5,.L16
        lui     a5,%hi(active_square)
        lw      a4,%lo(active_square)(a5)
        li      a5,9
        ble     a4,a5,.L16
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        addi    a4,a5,-10
        lui     a5,%hi(active_square)
        sw      a4,%lo(active_square)(a5)
        j       .L15
.L16:
        lw      a4,-52(s0)
        li      a5,104
        bne     a4,a5,.L17
        lui     a5,%hi(active_square)
        lw      a4,%lo(active_square)(a5)
        li      a5,89
        bgt     a4,a5,.L17
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        addi    a4,a5,10
        lui     a5,%hi(active_square)
        sw      a4,%lo(active_square)(a5)
        j       .L15
.L17:
        lw      a4,-52(s0)
        li      a5,105
        bne     a4,a5,.L15
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a4,a0
        li      a5,8
        bgt     a4,a5,.L15
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        addi    a4,a5,1
        lui     a5,%hi(active_square)
        sw      a4,%lo(active_square)(a5)
.L15:
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a4,a5
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        li      a2,1
        mv      a1,a5
        mv      a0,a4
        call    target_to_ppu_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_ppu_value
        j       .L23
.L12:
        lw      a4,-52(s0)
        li      a5,107
        bne     a4,a5,.L18
        call    reset_program
        j       .L23
.L18:
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
        lw      a5,-52(s0)
        srli    a5,a5,8
        andi    a5,a5,255
        sw      a5,-24(s0)
        lw      a4,-24(s0)
        li      a5,99
        ble     a4,a5,.L19
        li      a5,10
        j       .L20
.L19:
        li      a5,1
.L20:
        sw      a5,-28(s0)
        li      a1,100
        lw      a0,-24(s0)
        call    mod
        sw      a0,-32(s0)
        lw      a5,-52(s0)
        srli    a5,a5,16
        andi    a5,a5,255
        sw      a5,-36(s0)
        sw      zero,-20(s0)
        j       .L21
.L22:
        lw      a1,-20(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-24(s0)
        add     a5,a5,a4
        sw      a5,-40(s0)
        lui     a5,%hi(target_board)
        addi    a4,a5,%lo(target_board)
        lw      a5,-40(s0)
        add     a5,a4,a5
        li      a4,3
        sb      a4,0(a5)
        lui     a5,%hi(target_board)
        addi    a4,a5,%lo(target_board)
        lw      a5,-40(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a3,a5
        lui     a5,%hi(active_square)
        lw      a5,%lo(active_square)(a5)
        lw      a4,-40(s0)
        sub     a5,a4,a5
        seqz    a5,a5
        andi    a5,a5,255
        mv      a2,a5
        lw      a1,-40(s0)
        mv      a0,a3
        call    target_to_ppu_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_ppu_value
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L21:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-36(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a4,a5
        lw      a5,-20(s0)
        blt     a5,a4,.L22
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-36(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,-24(s0)
        sw      a4,0(a5)
        call    rsi_inst
.L23:
        nop
        lw      ra,60(sp)
        lw      s0,56(sp)
        addi    sp,sp,64
        jr      ra
        .size   exception_handler, .-exception_handler
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
# 166 "battleshipP1.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 167 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 168 "battleshipP1.c" 1
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
# 173 "battleshipP1.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 174 "battleshipP1.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 175 "battleshipP1.c" 1
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
        .globl  target_to_ppu_encoding
        .type   target_to_ppu_encoding, @function
target_to_ppu_encoding:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      a2,-44(s0)
        lw      a5,-40(s0)
        slli    a5,a5,24
        sw      a5,-20(s0)
        lw      a4,-36(s0)
        li      a5,1
        bne     a4,a5,.L27
        lw      a4,-20(s0)
        li      a5,4194304
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L28
.L27:
        lw      a4,-36(s0)
        li      a5,2
        bne     a4,a5,.L29
        lw      a4,-20(s0)
        li      a5,8388608
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L28
.L29:
        lw      a4,-36(s0)
        li      a5,3
        bne     a4,a5,.L28
        lw      a5,-36(s0)
        srai    a5,a5,8
        slli    a4,a5,20
        li      a5,12582912
        or      a4,a4,a5
        lw      a5,-36(s0)
        srai    a5,a5,16
        slli    a5,a5,17
        or      a4,a4,a5
        lw      a5,-36(s0)
        srai    a5,a5,8
        lui     a3,%hi(enemy_sunk)
        addi    a3,a3,%lo(enemy_sunk)
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a3,0(a5)
        li      a5,99
        ble     a3,a5,.L30
        li      a5,65536
        j       .L31
.L30:
        li      a5,0
.L31:
        or      a5,a5,a4
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
.L28:
        lw      a5,-44(s0)
        slli    a5,a5,15
        lw      a4,-20(s0)
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-20(s0)
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   target_to_ppu_encoding, .-target_to_ppu_encoding
        .align  2
        .globl  convert_encoding
        .type   convert_encoding, @function
convert_encoding:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        lw      a5,-36(s0)
        srai    a5,a5,22
        slli    a5,a5,1
        andi    a4,a5,2
        lw      a5,-36(s0)
        srai    a5,a5,21
        andi    a5,a5,1
        or      a5,a4,a5
        sw      a5,-20(s0)
        lw      a4,-20(s0)
        li      a5,2
        bne     a4,a5,.L34
        li      a5,3
        sw      a5,-20(s0)
        j       .L35
.L34:
        lw      a4,-20(s0)
        li      a5,3
        bne     a4,a5,.L35
        li      a5,2
        sw      a5,-20(s0)
.L35:
        lw      a5,-36(s0)
        srai    a5,a5,17
        andi    a5,a5,7
        lui     a4,%hi(ship_sizes)
        addi    a4,a4,%lo(ship_sizes)
        add     a5,a4,a5
        lbu     a5,0(a5)
        sw      a5,-28(s0)
        li      a5,-2147483648
        sw      a5,-24(s0)
        lw      a4,-36(s0)
        li      a5,2130706432
        and     a5,a4,a5
        lw      a4,-24(s0)
        or      a5,a4,a5
        sw      a5,-24(s0)
        lw      a5,-20(s0)
        slli    a5,a5,22
        lw      a4,-24(s0)
        or      a5,a4,a5
        sw      a5,-24(s0)
        lw      a4,-28(s0)
        li      a5,2
        beq     a4,a5,.L37
        lw      a4,-28(s0)
        li      a5,3
        bne     a4,a5,.L38
        lw      a4,-24(s0)
        li      a5,1048576
        or      a5,a4,a5
        sw      a5,-24(s0)
        j       .L37
.L38:
        lw      a4,-28(s0)
        li      a5,4
        bne     a4,a5,.L39
        lw      a4,-24(s0)
        li      a5,2097152
        or      a5,a4,a5
        sw      a5,-24(s0)
        j       .L37
.L39:
        lw      a4,-24(s0)
        li      a5,3145728
        or      a5,a4,a5
        sw      a5,-24(s0)
.L37:
        lw      a5,-36(s0)
        srai    a5,a5,14
        slli    a4,a5,17
        li      a5,917504
        and     a5,a4,a5
        lw      a4,-24(s0)
        or      a5,a4,a5
        sw      a5,-24(s0)
        lw      a5,-36(s0)
        srai    a5,a5,20
        slli    a4,a5,16
        li      a5,65536
        and     a5,a4,a5
        lw      a4,-24(s0)
        or      a5,a4,a5
        sw      a5,-24(s0)
        lw      a5,-24(s0)
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        .size   convert_encoding, .-convert_encoding
        .align  2
        .globl  reset_program
        .type   reset_program, @function
reset_program:
 #APP
# 217 "battleshipP1.c" 1
        addi sp,zero,0
# 0 "" 2
# 218 "battleshipP1.c" 1
        la a0,main
# 0 "" 2
# 219 "battleshipP1.c" 1
        rsi a0
# 0 "" 2
 #NO_APP
        .size   reset_program, .-reset_program
        .align  2
        .globl  rsi_inst
        .type   rsi_inst, @function
rsi_inst:
 #APP
# 223 "battleshipP1.c" 1
        addi sp,zero,-32
# 0 "" 2
# 224 "battleshipP1.c" 1
        la a0,PRE_ACCELERATOR_LABEL
# 0 "" 2
# 225 "battleshipP1.c" 1
        rsi a0
# 0 "" 2
 #NO_APP
        .size   rsi_inst, .-rsi_inst
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
        j       .L44
.L45:
        lw      a4,-20(s0)
        lw      a5,-36(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L44:
        lw      a4,-24(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L45
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
        ble     a5,zero,.L52
        j       .L49
.L50:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        sub     a5,a4,a5
        sw      a5,-20(s0)
.L49:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        bgt     a4,a5,.L50
        j       .L51
.L53:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
.L52:
        lw      a5,-20(s0)
        blt     a5,zero,.L53
.L51:
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
# 251 "battleshipP1.c" 1
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
        j       .L58
.L59:
        lw      a5,-20(s0)
        slli    a4,a5,24
        li      a5,2130706432
        and     a4,a4,a5
        lui     a5,%hi(my_board)
        addi    a3,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(target_board)
        addi    a4,a5,%lo(target_board)
        lw      a5,-20(s0)
        add     a5,a4,a5
        sb      zero,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L58:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L59
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
        lw      a5,-60(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        sw      a5,-28(s0)
        lw      a5,-56(s0)
        beq     a5,zero,.L61
        li      a5,10
        j       .L62
.L61:
        li      a5,1
.L62:
        sw      a5,-32(s0)
        lw      a5,-56(s0)
        beq     a5,zero,.L63
        lw      a5,-28(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L64
        li      a5,0
        j       .L65
.L63:
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
        ble     a4,a5,.L64
        li      a5,0
        j       .L65
.L64:
        sw      zero,-20(s0)
        j       .L66
.L68:
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
        li      a5,4194304
        and     a5,a4,a5
        beq     a5,zero,.L67
        li      a5,0
        j       .L65
.L67:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L66:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L68
        sw      zero,-24(s0)
        j       .L69
.L70:
        lw      a1,-24(s0)
        lw      a0,-32(s0)
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a5,a5,a4
        sw      a5,-36(s0)
        lw      a5,-36(s0)
        slli    a4,a5,24
        li      a5,2130706432
        and     a4,a4,a5
        li      a5,-2147483648
        or      a4,a4,a5
        lw      a5,-60(s0)
        slli    a3,a5,17
        li      a5,917504
        and     a5,a3,a5
        or      a4,a4,a5
        li      a5,4194304
        or      a4,a4,a5
        lw      a5,-56(s0)
        slli    a3,a5,20
        li      a5,1048576
        and     a5,a3,a5
        or      a4,a4,a5
        lw      a5,-24(s0)
        slli    a3,a5,14
        li      a5,114688
        and     a5,a3,a5
        or      a4,a4,a5
        lui     a5,%hi(my_board)
        addi    a3,a5,%lo(my_board)
        lw      a5,-36(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-36(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    convert_encoding
        mv      a5,a0
        mv      a0,a5
        call    send_ppu_value
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L69:
        lw      a4,-24(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L70
        lw      a1,-56(s0)
        li      a0,100
        call    mult
        mv      a4,a0
        lw      a5,-52(s0)
        add     a4,a4,a5
        lui     a5,%hi(my_positions)
        addi    a3,a5,%lo(my_positions)
        lw      a5,-60(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        li      a5,1
.L65:
        mv      a0,a5
        lw      ra,60(sp)
        lw      s0,56(sp)
        lw      s1,52(sp)
        addi    sp,sp,64
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
        j       .L72
.L75:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        bne     a4,a5,.L73
        li      a5,0
        j       .L74
.L73:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L72:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L75
        li      a5,1
.L74:
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
        j       .L77
.L82:
        sw      zero,-24(s0)
        j       .L78
.L81:
        sw      zero,-28(s0)
        j       .L79
.L80:
        lw      a1,-24(s0)
        li      a0,100
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
.L79:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L80
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L78:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L81
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L77:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L82
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
        j       .L84
.L85:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      zero,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L84:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L85
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
        beq     a5,zero,.L88
        li      a5,10
        j       .L89
.L88:
        li      a5,1
.L89:
        sw      a5,-28(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L90
        lw      a5,-24(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a4,a4,a5
        li      a5,99
        ble     a4,a5,.L91
        li      a5,0
        j       .L92
.L90:
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
        ble     a4,a5,.L91
        li      a5,0
        j       .L92
.L91:
        sw      zero,-20(s0)
        j       .L93
.L96:
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
        beq     a4,a5,.L94
        lw      a1,-20(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-40(s0)
        add     a5,a4,a5
        lui     a4,%hi(target_board)
        addi    a4,a4,%lo(target_board)
        add     a5,a4,a5
        lbu     a5,0(a5)
        andi    a5,a5,1
        beq     a5,zero,.L95
.L94:
        li      a5,0
        j       .L92
.L95:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L93:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        blt     a4,a5,.L96
        li      a5,1
.L92:
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
        j       .L98
.L105:
        lw      a5,-20(s0)
        lw      a4,-36(s0)
        add     a5,a4,a5
        lbu     a4,0(a5)
        li      a5,99
        bleu    a4,a5,.L99
        li      a5,10
        j       .L100
.L99:
        li      a5,1
.L100:
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
        j       .L101
.L104:
        lw      a1,-24(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-32(s0)
        add     a5,a4,a5
        lw      a4,-40(s0)
        bne     a4,a5,.L102
        li      a5,1
        j       .L103
.L102:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L101:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a4,a5
        lw      a5,-24(s0)
        blt     a5,a4,.L104
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L98:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L105
        li      a5,0
.L103:
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
        ble     a4,a5,.L107
        li      a5,10
        j       .L108
.L107:
        li      a5,1
.L108:
        sw      a5,-36(s0)
        lw      a4,-64(s0)
        li      a5,99
        ble     a4,a5,.L109
        li      a5,10
        j       .L110
.L109:
        li      a5,1
.L110:
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
        j       .L111
.L116:
        sw      zero,-24(s0)
        j       .L112
.L115:
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
        bne     s1,a5,.L113
        li      a5,0
        j       .L114
.L113:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L112:
        lw      a4,-24(s0)
        lw      a5,-32(s0)
        blt     a4,a5,.L115
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L111:
        lw      a4,-20(s0)
        lw      a5,-28(s0)
        blt     a4,a5,.L116
        li      a5,1
.L114:
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
        j       .L118
.L121:
        lui     a5,%hi(target_board)
        addi    a4,a5,%lo(target_board)
        lw      a5,-20(s0)
        add     a5,a4,a5
        lbu     a4,0(a5)
        li      a5,2
        bne     a4,a5,.L119
        lw      a1,-20(s0)
        lw      a0,-36(s0)
        call    square_in_configuration
        mv      a5,a0
        bne     a5,zero,.L119
        li      a5,0
        j       .L120
.L119:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L118:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L121
        sw      zero,-24(s0)
        j       .L122
.L126:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
        j       .L123
.L125:
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
        bne     a5,zero,.L124
        li      a5,0
        j       .L120
.L124:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L123:
        lw      a4,-28(s0)
        li      a5,4
        ble     a4,a5,.L125
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L122:
        lw      a4,-24(s0)
        li      a5,3
        ble     a4,a5,.L126
        li      a5,1
.L120:
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
        j       .L128
.L136:
        lui     a5,%hi(enemy_sunk)
        addi    a4,a5,%lo(enemy_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        beq     a4,a5,.L129
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
        j       .L130
.L129:
        sw      zero,-24(s0)
        j       .L131
.L135:
        sw      zero,-28(s0)
        j       .L132
.L134:
        lw      a2,-24(s0)
        lw      a1,-28(s0)
        lw      a0,-20(s0)
        call    check_valid_position
        mv      a5,a0
        beq     a5,zero,.L133
        lw      a1,-24(s0)
        li      a0,100
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
.L133:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L132:
        lw      a4,-28(s0)
        li      a5,99
        ble     a4,a5,.L134
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L131:
        lw      a4,-24(s0)
        li      a5,1
        ble     a4,a5,.L135
.L130:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L128:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L136
        sw      zero,-32(s0)
        j       .L137
.L150:
        sw      zero,-36(s0)
        j       .L138
.L140:
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
        bne     a5,zero,.L139
        lw      a5,-36(s0)
        addi    a5,a5,-1
        sw      a5,-36(s0)
.L139:
        lw      a5,-36(s0)
        addi    a5,a5,1
        sw      a5,-36(s0)
.L138:
        lw      a4,-36(s0)
        li      a5,4
        ble     a4,a5,.L140
        addi    a5,s0,-64
        mv      a0,a5
        call    check_valid_configuration
        mv      a5,a0
        bne     a5,zero,.L141
        lw      a5,-32(s0)
        addi    a5,a5,-1
        sw      a5,-32(s0)
        j       .L142
.L141:
        sw      zero,-40(s0)
        j       .L143
.L149:
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
        bleu    a4,a5,.L144
        li      a5,10
        j       .L145
.L144:
        li      a5,1
.L145:
        sb      a5,-59(s0)
        sw      zero,-44(s0)
        j       .L146
.L148:
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
        bne     a5,zero,.L147
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
.L147:
        lw      a5,-44(s0)
        addi    a5,a5,1
        sw      a5,-44(s0)
.L146:
        lbu     a5,-57(s0)
        lw      a4,-44(s0)
        blt     a4,a5,.L148
        lw      a5,-40(s0)
        addi    a5,a5,1
        sw      a5,-40(s0)
.L143:
        lw      a4,-40(s0)
        li      a5,4
        ble     a4,a5,.L149
.L142:
        lw      a5,-32(s0)
        addi    a5,a5,1
        sw      a5,-32(s0)
.L137:
        lw      a4,-32(s0)
        li      a5,8192
        addi    a5,a5,-193
        ble     a4,a5,.L150
        li      a5,-1
        sw      a5,-48(s0)
        sw      zero,-52(s0)
        sw      zero,-56(s0)
        j       .L151
.L153:
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        lw      a4,-48(s0)
        bge     a4,a5,.L152
        lui     a5,%hi(hit_counts)
        addi    a4,a5,%lo(hit_counts)
        lw      a5,-56(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-48(s0)
        lw      a5,-56(s0)
        sw      a5,-52(s0)
.L152:
        lw      a5,-56(s0)
        addi    a5,a5,1
        sw      a5,-56(s0)
.L151:
        lw      a4,-56(s0)
        li      a5,99
        ble     a4,a5,.L153
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
        j       .L156
.L164:
        lui     a5,%hi(my_sunk)
        addi    a4,a5,%lo(my_sunk)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-1
        bne     a4,a5,.L157
        li      a5,1
        sw      a5,-24(s0)
        lui     a5,%hi(my_positions)
        addi    a4,a5,%lo(my_positions)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,99
        ble     a4,a5,.L158
        li      a5,10
        j       .L159
.L158:
        li      a5,1
.L159:
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
        j       .L160
.L162:
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
        bne     a5,zero,.L161
        sw      zero,-24(s0)
.L161:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L160:
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a4,a5
        lw      a5,-28(s0)
        blt     a5,a4,.L162
        lw      a5,-24(s0)
        beq     a5,zero,.L157
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
        j       .L163
.L157:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L156:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L164
        li      a5,0
.L163:
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
        j       .L166
.L168:
        nop
.L167:
        call    rand
        mv      a5,a0
        li      a1,100
        mv      a0,a5
        call    mod
        mv      s1,a0
        call    rand
        mv      a5,a0
        andi    a5,a5,1
        lw      a2,-20(s0)
        mv      a1,a5
        mv      a0,s1
        call    place_ship
        mv      a5,a0
        beq     a5,zero,.L167
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L166:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L168
 #APP
# 487 "battleshipP1.c" 1
        PRE_ACCELERATOR_LABEL:
# 0 "" 2
 #NO_APP
        call    run_accelerator
        mv      a4,a0
        lui     a5,%hi(ai_target)
        sw      a4,%lo(ai_target)(a5)
.L169:
        j       .L169
        .size   main, .-main
        .ident  "GCC: (g04696df09) 14.2.0"
        .section        .note.GNU-stack,"",@progbits