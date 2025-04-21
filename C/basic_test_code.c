#define SELECT_BIT 0x00008000

int toSnd;
int activeSquare;
int board[100];

int generate_encoding(int, int, int, int, int, int, int);
void send_value(int);

void entry_point() {
    asm volatile ("j main");
    asm volatile ("rdi a0");
    asm volatile ("call exception_handler");
    asm volatile ("rti");
}

void exception_handler(int num) {
    board[activeSquare] &= ~SELECT_BIT;
    send_value(board[activeSquare]);
    if(num == 102) { // LEFT
        activeSquare -= 1;
    } else if(num == 103) { // UP
        activeSquare -= 10;
    } else if(num == 104) { // DOWN
        activeSquare += 10;
    } else if(num == 105) { // RIGHT
        activeSquare += 1;
    } else if(num == 106) { // FIRE
        
    }
    board[activeSquare] |= SELECT_BIT;
    send_value(board[activeSquare]);
}

int mult(int a, int b) {
    int result = 0;
    for(int i = 0; i < b; i++) {
        result += a;
    }
    return result;
}

void send_value(int value) {
    toSnd = value;
    asm volatile ("lui a0,%hi(toSnd)");
    asm volatile ("lw a0,%lo(toSnd)(a0)");
    asm volatile ("ugs a0");
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
        send_value(generate_encoding(1, size, 3, pos + mult(i,inc), i, v, 0));
    }
}

int main() {
    place_ship(22, 2, 0);
    place_ship(45, 3, 1);
    place_ship(28, 3, 1);
    place_ship(83, 4, 0);
    place_ship(51, 5, 1);
    activeSquare = 55;
    board[activeSquare] |= SELECT_BIT;
    send_value(board[activeSquare]);
    while(1) {
        // do nothing
    }
}