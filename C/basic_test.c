int toSnd;

void send_value(int value) {
    toSnd = value;
    asm volatile ("lui a0,%hi(toSnd)");
    asm volatile ("lw a0,%lo(toSnd)(a0)");
    asm volatile ("ugs a0");
}

void place_ship(int pos, int size, int v) {
    
}

int main() {

}