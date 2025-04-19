int toSnd;
int activeSquare;
int board[100];

int mult(int, int);
int mod(int, int);

void entry_point() {
    asm volatile ("j main");
    asm volatile ("rdi a0");
    asm volatile ("call interrupt_handler");
}

void interrupt_handler(int num) {
    if(num == 102) { // LEFT
        if(mod(activeSquare, 10)) {
            board[activeSquare] &= 0xffff7fff;
            toSnd = board[activeSquare];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
            activeSquare--;
            board[activeSquare] |= 1 << 15;
            toSnd = board[activeSquare];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
        }
    } else if(num == 103) { // UP
        if(activeSquare > 9) {
            board[activeSquare] &= 0xffff7fff;
            toSnd = board[activeSquare];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
            activeSquare -= 10;
            board[activeSquare] |= 1 << 15;
            toSnd = board[activeSquare];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
        }
    } else if(num == 104) { // DOWN
        if(activeSquare < 90) {
            board[activeSquare] &= 0xffff7fff;
            toSnd = board[activeSquare];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
            activeSquare += 10;
            board[activeSquare] |= 1 << 15;
            toSnd = board[activeSquare];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
        }
    } else if(num == 105) { // RIGHT
        if(mod(activeSquare, 10) < 9) {
            board[activeSquare] &= 0xffff7fff;
            toSnd = board[activeSquare];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
            activeSquare++;
            board[activeSquare] |= 1 << 15;
            toSnd = board[activeSquare];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
        }
    } else { // FIRE

    }
}

int mult(int a, int b) {
    int result = 0;
    for(int i = 0; i < b; i++) {
        result += a;
    }
    return result;
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
}

int generate_encoding(int size, int pos, int seg, int v, int sel) {
    int result = 0;
    result |= size << 24;
    result |= 0x00c00000;
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

void place_ship(int size, int pos, int v) {
    int inc = v ? 10 : 1;
    for(int i = 0; i < size; i++) {
        int curPos = pos+mult(i,inc);
        board[pos+mult(i,inc)] = generate_encoding(size, curPos, i, v, 0);
        toSnd = board[curPos];
        asm volatile ("lui a0,%hi(toSnd)");
        asm volatile ("lw a0,%lo(toSnd)(a0)");
        asm volatile ("ugs a0");
    }
}

int main() {
    place_ship(2, 22, 0);
    place_ship(3, 54, 1);
    place_ship(3, 66, 0);
    place_ship(4, 10, 1);
    place_ship(5, 82, 0);
    board[55] |= 1 << 15;
    toSnd = board[55];
    asm volatile ("lui a0,%hi(toSnd)");
    asm volatile ("lw a0,%lo(toSnd)(a0)");
    asm volatile ("ugs a0");
}