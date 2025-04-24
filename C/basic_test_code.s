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
# 16 "basic_test_code.c" 1
# 0 "" 2
# 17 "basic_test_code.c" 1
        rdi a0
# 0 "" 2
# 18 "basic_test_code.c" 1
        call exception_handler
# 0 "" 2
# 19 "basic_test_code.c" 1
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
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        lw      a4,-20(s0)
        li      a5,99
        bgt     a4,a5,.L3
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,12582912
        bne     a4,a5,.L4
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,-4194304
        addi    a5,a5,-1
        and     a4,a4,a5
        lui     a5,%hi(my_board)
        addi    a3,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        li      a0,101
        call    send_board_value
        j       .L5
.L4:
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,4194304
        or      a4,a4,a5
        lui     a5,%hi(my_board)
        addi    a3,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        li      a0,100
        call    send_board_value
.L5:
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
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
        j       .L14
.L3:
        lw      a4,-20(s0)
        li      a5,100
        bne     a4,a5,.L7
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
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
        j       .L14
.L7:
        lw      a4,-20(s0)
        li      a5,101
        bne     a4,a5,.L8
        lui     a5,%hi(myTurn)
        sw      zero,%lo(myTurn)(a5)
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
        j       .L14
.L8:
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
        lw      a4,-20(s0)
        li      a5,102
        bne     a4,a5,.L9
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a5,a0
        beq     a5,zero,.L10
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,-1
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L10
.L9:
        lw      a4,-20(s0)
        li      a5,103
        bne     a4,a5,.L11
        lui     a5,%hi(activeSquare)
        lw      a4,%lo(activeSquare)(a5)
        li      a5,9
        ble     a4,a5,.L10
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,-10
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L10
.L11:
        lw      a4,-20(s0)
        li      a5,104
        bne     a4,a5,.L12
        lui     a5,%hi(activeSquare)
        lw      a4,%lo(activeSquare)(a5)
        li      a5,89
        bgt     a4,a5,.L10
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,10
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L10
.L12:
        lw      a4,-20(s0)
        li      a5,105
        bne     a4,a5,.L13
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        li      a1,10
        mv      a0,a5
        call    mod
        mv      a4,a0
        li      a5,8
        bgt     a4,a5,.L10
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        addi    a4,a5,1
        lui     a5,%hi(activeSquare)
        sw      a4,%lo(activeSquare)(a5)
        j       .L10
.L13:
        lw      a4,-20(s0)
        li      a5,106
        bne     a4,a5,.L10
        lui     a5,%hi(myTurn)
        lw      a5,%lo(myTurn)(a5)
        beq     a5,zero,.L10
        lui     a5,%hi(activeSquare)
        lw      a5,%lo(activeSquare)(a5)
        mv      a0,a5
        call    send_board_value
.L10:
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
.L14:
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
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
        ble     a5,zero,.L20
        j       .L17
.L18:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        sub     a5,a4,a5
        sw      a5,-20(s0)
.L17:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        bge     a4,a5,.L18
        j       .L19
.L21:
        lw      a4,-20(s0)
        lw      a5,-24(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
.L20:
        lw      a5,-20(s0)
        blt     a5,zero,.L21
.L19:
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
# 88 "basic_test_code.c" 1
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
        j       .L26
.L27:
        lw      a4,-20(s0)
        lw      a5,-36(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L26:
        lw      a4,-24(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L27
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
# 102 "basic_test_code.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 103 "basic_test_code.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 104 "basic_test_code.c" 1
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
# 109 "basic_test_code.c" 1
        lui a0,%hi(toSnd)
# 0 "" 2
# 110 "basic_test_code.c" 1
        lw a0,%lo(toSnd)(a0)
# 0 "" 2
# 111 "basic_test_code.c" 1
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
        beq     a4,a5,.L33
        lw      a4,-40(s0)
        li      a5,3
        bne     a4,a5,.L34
        lw      a4,-20(s0)
        li      a5,1048576
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L33
.L34:
        lw      a4,-40(s0)
        li      a5,4
        bne     a4,a5,.L35
        lw      a4,-20(s0)
        li      a5,2097152
        or      a5,a4,a5
        sw      a5,-20(s0)
        j       .L33
.L35:
        lw      a4,-20(s0)
        li      a5,3145728
        or      a5,a4,a5
        sw      a5,-20(s0)
.L33:
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
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        sw      s1,36(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      a2,-44(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L38
        li      a5,10
        j       .L39
.L38:
        li      a5,1
.L39:
        sw      a5,-28(s0)
        lw      a5,-44(s0)
        beq     a5,zero,.L40
        lw      a5,-40(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-28(s0)
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
        lw      a5,-40(s0)
        addi    a5,a5,-1
        mv      a1,a5
        lw      a0,-28(s0)
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
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a5,a4,a5
        lui     a4,%hi(my_board)
        addi    a4,a4,%lo(my_board)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,0(a5)
        li      a5,12582912
        and     a4,a4,a5
        li      a5,12582912
        bne     a4,a5,.L44
        li      a5,0
        j       .L42
.L44:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L43:
        lw      a4,-20(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L45
        sw      zero,-24(s0)
        j       .L46
.L47:
        lw      a1,-24(s0)
        lw      a0,-28(s0)
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a5,a5,a4
        sw      a5,-32(s0)
        lw      a1,-28(s0)
        lw      a0,-24(s0)
        call    mult
        mv      a4,a0
        lw      a5,-36(s0)
        add     a3,a4,a5
        li      a6,0
        lw      a5,-44(s0)
        lw      a4,-24(s0)
        li      a2,3
        lw      a1,-40(s0)
        li      a0,1
        call    generate_encoding
        mv      a3,a0
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-32(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        sw      a3,0(a5)
        lui     a5,%hi(my_board)
        addi    a4,a5,%lo(my_board)
        lw      a5,-32(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a5,0(a5)
        mv      a0,a5
        call    send_ppu_value
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L46:
        lw      a4,-24(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L47
        li      a5,1
.L42:
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        lw      s1,36(sp)
        addi    sp,sp,48
        jr      ra
        .size   place_ship, .-place_ship
        .align  2
        .globl  initialize_boards
        .type   initialize_boards, @function
initialize_boards:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L49
.L50:
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
.L49:
        lw      a4,-20(s0)
        li      a5,99
        ble     a4,a5,.L50
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
        .size   initialize_boards, .-initialize_boards
        .align  2
        .globl  main
        .type   main, @function
main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        sw      s1,20(sp)
        sw      s2,16(sp)
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
        lui     a5,%hi(myTurn)
        li      a4,1
        sw      a4,%lo(myTurn)(a5)
        call    initialize_boards
        sw      zero,-20(s0)
        j       .L52
.L54:
        call    rand
        mv      a5,a0
        li      a1,100
        mv      a0,a5
        call    mod
        mv      s2,a0
        lui     a5,%hi(ship_sizes)
        addi    a4,a5,%lo(ship_sizes)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      s1,0(a5)
        call    rand
        mv      a5,a0
        andi    a5,a5,1
        mv      a2,a5
        mv      a1,s1
        mv      a0,s2
        call    place_ship
        mv      a5,a0
        bne     a5,zero,.L53
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
.L53:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L52:
        lw      a4,-20(s0)
        li      a5,4
        ble     a4,a5,.L54
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
.L55:
        j       .L55
        .size   main, .-main
        .ident  "GCC: (g04696df09) 14.2.0"
        .section        .note.GNU-stack,"",@progbits