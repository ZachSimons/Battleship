#define SELECT_BIT 0x00008000

int toSnd;
int activeSquare;
int myTurn;
int board[100];
int my_board[100];
int ship_sizes[5];
int my_positions[5];
int my_sunk[5];

int generate_encoding(int, int, int, int, int, int, int);
int mod(int, int);
int mult(int, int);
void send_ppu_value(int);
void send_board_value(int);
int check_sunk();
int check_lose();
void reset_program();

void entry_point() {
    asm volatile ("j main");
    asm volatile ("rdi a0");
    asm volatile ("call exception_handler");
    asm volatile ("rti");
}

void exception_handler(int num) {
    if(num < 100) {
        if(((my_board[num] >> 22) & 3) == 3) {
            my_board[num] = my_board[num] & 0xffbfffff;
            send_ppu_value(my_board[num]);
            int isSunk = check_sunk();
            if(isSunk) {
                isSunk--;
                if(check_lose()) {
                    send_board_value(0x00020000 | (isSunk << 8) | my_positions[isSunk]);
                } else {
                    send_board_value(0x00010000 | (isSunk << 8) | my_positions[isSunk]);
                    myTurn = 1;
                }
            } else {
                send_board_value(101);
                myTurn = 1;
            }
        } else {
            my_board[num] = my_board[num] | 0x00400000;
            send_ppu_value(my_board[num]);
            send_board_value(100);
            myTurn = 1;
        }
    } else if(num == 100) {
        myTurn = 0;
        board[activeSquare] |= (1 << 22) | SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    } else if(num == 101) {
        myTurn = 0;
        board[activeSquare] |= (2 << 22) | SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    } else if(num < 107) {
        board[activeSquare] &= ~SELECT_BIT;
        send_ppu_value(board[activeSquare]);
        if(num == 102) { // LEFT
            if(mod(activeSquare, 10)) {
                activeSquare -= 1;
            }
        } else if(num == 103) { // UP
            if(activeSquare > 9) {
                activeSquare -= 10;
            }
        } else if(num == 104) { // DOWN
            if(activeSquare < 90) {
                activeSquare += 10;
            }
        } else if(num == 105) { // RIGHT
            if(mod(activeSquare, 10) < 9) {
                activeSquare += 1;
            }
        } else if(num == 106) { // FIRE
            if(myTurn && ((board[activeSquare] & 0x00c00000) == 0)) {
                send_board_value(activeSquare);
            }
        }
        board[activeSquare] |= SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    } else if(num == 107) {
        reset_program();
    } else {
        myTurn = 0;
        int ship = (num & 0x0000ff00) >> 8;
        int pos = num & 0x000000ff;
        int square = mod(pos, 100);
        int inc = pos > 99 ? 10 : 1;
        for(int i = 0; i < ship_sizes[ship]; i++) {
            int grid = square + mult(inc, i);
            board[grid] = generate_encoding(0, ship_sizes[ship], 3, grid, i, pos > 99, grid == activeSquare);
            send_ppu_value(board[grid]);
        }
    }
}

int mod(int a, int b) {
    if(a > 0) {
        while(a >= b) {
            a -= b;
        }
    } else {
        while(a < 0) {
            a += b;
        }
    }
    return a;
}

int rand() {
    int a = 10;
    asm volatile ("ldr a0");
    return a;
}

int mult(int a, int b) {
    int result = 0;
    for(int i = 0; i < b; i++) {
        result += a;
    }
    return result;
}

void send_ppu_value(int value) {
    toSnd = value;
    asm volatile ("lui a0,%hi(toSnd)");
    asm volatile ("lw a0,%lo(toSnd)(a0)");
    asm volatile ("ugs a0");
}

void send_board_value(int value) {
    toSnd = value;
    asm volatile ("lui a0,%hi(toSnd)");
    asm volatile ("lw a0,%lo(toSnd)(a0)");
    asm volatile ("snd a0");
}

int generate_encoding(int board, int size, int state, int pos, int seg, int v, int sel) {
    int result = board << 31;
    result |= pos << 24;
    result |= state << 22;
    if(size == 2) {
        result |= 0x00000000;
    } else if(size == 3) {
        result |= 0x00100000;
    } else if(size == 4) {
        result |= 0x00200000;
    } else {
        result |= 0x00300000;
    }
    result |= seg << 17;
    result |= v << 16;
    result |= sel << 15;
    return result;
}

int place_ship(int pos, int ship, int v) {
    int size = ship_sizes[ship];
    int inc = v ? 10 : 1;
    if(v) {
        if(pos + mult(inc, size-1) > 99) {
            return 0;
        }
    } else {
        if(mod(pos, 10) + mult(inc, size-1) > 9) {
            return 0;
        }
    }
    for(int i = 0; i < size; i++) {
        if((my_board[pos + mult(inc, i)] & 0x00c00000) == 0x00c00000) {
            return 0;
        }
    }
    my_positions[ship] = pos + mult(100, v);
    for(int i = 0; i < size; i++) {
        int square = pos + mult(inc,i);
        my_board[square] = generate_encoding(1, size, 3, pos + mult(i,inc), i, v, 0);
        send_ppu_value(my_board[square]);
    }
    return 1;
}

int check_sunk() {
    for(int i = 0; i < 5; i++) {
        if(my_sunk[i] == 0) {
            int pos = mod(my_positions[i], 100);
            int inc = my_positions[i] > 99 ? 10 : 1;
            int valid = 1;
            for(int j = 0; j < ship_sizes[i]; j++) {
                if((my_board[pos + mult(inc,j)] & 0x00c00000) != 0x00800000) {
                    valid = 0;
                    break;
                }
            }
            if(valid) {
                my_sunk[i] = 1;
                return i+1;
            }
        }
    }
    return 0;
}

int check_lose() {
    for(int i = 0; i < 5; i++) {
        if(my_sunk[i] == -1) {
            return 0;
        }
    }
    return 1;
}

void reset_program() {
    asm volatile ("addi sp,zero,0");
    asm volatile ("la a0,main");
    asm volatile ("rsi a0");
}

void initialize_boards() {
    for(int i = 0; i < 100; i++) {
        board[i] = i << 24;
        my_board[i] = 0x80000000 | (i << 24);
    }
}

int main() {
    ship_sizes[0] = 2;
    ship_sizes[1] = 3;
    ship_sizes[2] = 3;
    ship_sizes[3] = 4;
    ship_sizes[4] = 5;
    my_positions[0] = -1;
    my_positions[1] = -1;
    my_positions[2] = -1;
    my_positions[3] = -1;
    my_positions[4] = -1;
    myTurn = 1;
    initialize_boards();
    for(int i = 0; i < 5; i++) {
        if(place_ship(mod(rand(), 100), ship_sizes[i], rand() & 1) == 0) {
            i--;
        }
    }
    activeSquare = 55;
    board[activeSquare] |= SELECT_BIT;
    send_ppu_value(board[activeSquare]);
    while(1) {
        // do nothing
    }
}