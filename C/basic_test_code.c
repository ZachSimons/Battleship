#define SELECT_BIT 0x00008000

int toSnd;
int activeSquare;
int myTurn;
int board[100];
int my_board[100];

int generate_encoding(int, int, int, int, int, int, int);
int mod(int, int);
void send_ppu_value(int);
void send_board_value(int);

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
            send_board_value(101);
        } else {
            my_board[num] = my_board[num] | 0x00400000;
            send_ppu_value(my_board[num]);
            send_board_value(100);
        }
        myTurn = 1;
        board[activeSquare] |= SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    } else if(num == 100) {
        myTurn = 0;
        board[activeSquare] |= (1 << 22) | SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    } else if(num == 101) {
        myTurn = 0;
        board[activeSquare] |= (2 << 22) | SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    } else {
        board[activeSquare] &= ~SELECT_BIT;
        send_ppu_value(board[activeSquare]);
        if(num == 102) { // LEFT
            if(mod(activeSquare, 10) > 0) {
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
            if(myTurn) {
                send_board_value(activeSquare);
            }
        }
        board[activeSquare] |= SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    }
}

int mod(int a, int b) {
    if(a > 0) {
        while(a > b) {
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

void place_ship(int pos, int size, int v) {
    int inc = v ? 10 : 1;
    for(int i = 0; i < size; i++) {
        int square = pos + mult(inc,i);
        my_board[square] = generate_encoding(1, size, 3, pos + mult(i,inc), i, v, 0);
        send_ppu_value(my_board[square]);
    }
}

void initialize_boards() {
    for(int i = 0; i < 100; i++) {
        board[i] = i << 24;
        my_board[i] = 0x80000000 | (i << 24);
    }
}

int main() {
    myTurn = 1;
    initialize_boards();
    place_ship(mod(rand(), 100), 2, 0);
    place_ship(mod(rand(), 100), 3, 1);
    place_ship(mod(rand(), 100), 3, 1);
    place_ship(mod(rand(), 100), 4, 0);
    place_ship(mod(rand(), 100), 5, 0);
    activeSquare = 55;
    board[activeSquare] |= SELECT_BIT;
    send_ppu_value(board[activeSquare]);
    while(1) {
        // do nothing
    }
}