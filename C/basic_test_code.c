int toSnd;

void entry_point() {
    asm volatile ("j main");
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

int generate_encoding(int size, int pos, int seg, int v, int sel) {
    int result = 0x80000000;
    result |= pos << 24;
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

void place_ship(int pos, int size, int v) {
    int inc = v ? 10 : 1;
    for(int i = 0; i < size; i++) {
        send_value(generate_encoding(size, pos + mult(i,inc), i, v, 0));
    }
}

int main() {
    /*
    place_ship(22, 2, 0);
    place_ship(65, 3, 1);
    place_ship(28, 3, 1);
    place_ship(83, 4, 0);
    place_ship(51, 5, 1);
    */
   send_value(generate_encoding(2, 25, 0, 0, 0));
   send_value(generate_encoding(2, 26, 1, 0, 0));
   send_value(generate_encoding(3, 27, 0, 1, 0));
   send_value(generate_encoding(3, 37, 1, 1, 0));
   send_value(generate_encoding(3, 47, 2, 1, 0));
   send_value(generate_encoding(4, 65, 0, 0, 0));
   send_value(generate_encoding(4, 66, 1, 0, 0));
   send_value(generate_encoding(4, 67, 2, 0, 0));
   send_value(generate_encoding(4, 68, 3, 0, 0));
   send_value(generate_encoding(5, 51, 0, 1, 0));
   send_value(generate_encoding(5, 61, 1, 1, 0));
   send_value(generate_encoding(5, 71, 2, 1, 0));
   send_value(generate_encoding(5, 81, 3, 1, 0));
   send_value(generate_encoding(5, 91, 4, 1, 0));
}