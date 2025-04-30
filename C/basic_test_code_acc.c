#define SELECT_BIT 0x00008000
#define SET_MY_TURN 0x00003000
#define SET_NOT_MY_TURN 0x00002000

int toSnd;
int toSnd_board;
int activeSquare;
int myTurn;
int board[100];
int my_board[100];
int ship_sizes[5];
int my_positions[5];
int my_sunk[5];
int enemy_sunk[5];

#define ACCELERATOR_COUNT 1000
int possible_positions[5][200];
int hit_counts[100];
int configuration[5];
int ai_target;
int ai_old_target;
int acc_result;
int ai_ran;

int generate_encoding(int, int, int, int, int, int, int);
int generate_acc_encoding(int, int, int, int);
int mod(int, int);
int mult(int, int);
void send_ppu_value(int);
void send_board_value(int);
void send_accel_value(int);
int check_sunk();
int check_lose();
void rsi_instruction();

void entry_point() {
    asm volatile ("j main");
    asm volatile ("rdi a0");
    asm volatile ("call exception_handler");
    asm volatile ("rti");
}

void exception_handler(int num) {
    if(num < 100) {
        if(((my_board[num] & 0x00c00000) >> 22) == 3) {
            my_board[num] = my_board[num] & 0xffbfffff;
            send_ppu_value(my_board[num]);
            int isSunk = check_sunk();
            if(isSunk) {
                isSunk--;
                if(check_lose()) {
                    send_board_value(0x00020000 | (isSunk << 8) | my_positions[isSunk]);
                    send_ppu_value(0x00000800);
                } else {
                    send_board_value(0x00010000 | (isSunk << 8) | my_positions[isSunk]);
                    send_ppu_value(SET_MY_TURN);
                    myTurn = 1;
                }
            } else {
                send_board_value(101);
                send_ppu_value(SET_MY_TURN);
                myTurn = 1;
            }
        } else if(((my_board[num] & 0x00c00000) >> 22) == 0) {
            my_board[num] = my_board[num] | 0x00400000;
            send_ppu_value(my_board[num]);
            send_board_value(100);
            send_ppu_value(SET_MY_TURN);
            myTurn = 1;
        } else {
            if(((my_board[num] & 0x00c00000) >> 22) == 1) {
                send_board_value(100);
                send_ppu_value(SET_MY_TURN);
                myTurn = 1;
            } else {
                send_board_value(101);
                send_ppu_value(SET_MY_TURN);
                myTurn = 1;
            }
        }
    } else if(num == 100) {
        myTurn = 0;
        ai_ran = 0;
        send_ppu_value(SET_NOT_MY_TURN);
        send_ppu_value(board[ai_target]);
        board[activeSquare] |= (1 << 22) | SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    } else if(num == 101) {
        myTurn = 0;
        ai_ran = 0;
        send_ppu_value(SET_NOT_MY_TURN);
        send_ppu_value(board[ai_target]);
        board[activeSquare] |= (2 << 22) | SELECT_BIT;
        send_ppu_value(board[activeSquare]);
    } else if(num < 107) {
        board[activeSquare] &= ~SELECT_BIT;
        send_ppu_value(board[activeSquare] | (((activeSquare == ai_target) && ((board[activeSquare] & 0x00c00000) == 0)) ? 1 << 14 : 0));
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
        send_ppu_value(board[activeSquare] | (((activeSquare == ai_target) && ((board[activeSquare] & 0x00c00000) == 0)) ? 1 << 14 : 0));
    } else if(num == 107) {
        send_board_value(toSnd_board);
    } else if(num < 0x00040000) {
        myTurn = 0;
        ai_ran = 0;
        send_ppu_value(SET_NOT_MY_TURN);
        send_ppu_value(board[ai_target]);
        int ship = (num & 0x0000ff00) >> 8;
        int pos = num & 0x000000ff;
        int square = mod(pos, 100);
        int inc = pos > 99 ? 10 : 1;
        enemy_sunk[ship] = pos;
        for(int i = 0; i < ship_sizes[ship]; i++) {
            int grid = square + mult(inc, i);
            board[grid] = generate_encoding(0, ship_sizes[ship], 3, grid, i, pos > 99, grid == activeSquare);
            send_ppu_value(board[grid]);
        }
        if(num & 0x00020000) {
            send_ppu_value(0x00000c00);
        }
    } else {
        send_board_value(107);
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
    toSnd_board = value;
    asm volatile ("lui a0,%hi(toSnd_board)");
    asm volatile ("lw a0,%lo(toSnd_board)(a0)");
    asm volatile ("snd a0");
}

void send_accel_value(int value) {
    toSnd = value;
    asm volatile ("lui a0,%hi(toSnd)");
    asm volatile ("lw a0,%lo(toSnd)(a0)");
    asm volatile ("uad a0");
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

int generate_acc_encoding(int ship1, int pos1, int ship2, int pos2) {
    int result = 0;
    result |= (mod(pos1, 100) << 25) | ((pos1 > 99) << 24) | (ship1 << 21);
    result |= (mod(pos2, 100) << 14) | ((pos2 > 99) << 13) | (ship2 << 10);
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
        if(!my_sunk[i]) {
            return 0;
        }
    }
    return 1;
}

void initialize_boards() {
    for(int i = 0; i < 100; i++) {
        board[i] = i << 24;
        my_board[i] = 0x80000000 | (i << 24);
    }
}

void clear_possible_positions() {
    for(int ship = 0; ship < 5; ship++) {
        for(int v = 0; v < 2; v++) {
            for(int square = 0; square < 100; square++) {
                possible_positions[ship][mult(100,v) + square] = 0;
            }
        }
    }
}

void clear_hit_counts() {
    for(int i = 0; i < 100; i++) {
        hit_counts[i] = 0;
    }
}

void clear_accelerator_data() {
    clear_possible_positions();
    clear_hit_counts();
}

int check_valid_position(int ship, int square, int v) {
    int size = ship_sizes[ship];
    int inc = v ? 10 : 1;
    if(v) {
        if(square + mult(inc,(size-1)) > 99) {
            return 0;
        }
    } else {
        if (mod(square,10) + mult(inc,(size-1)) > 9) {
            return 0;
        }
    }
    for(int i = 0; i < size; i++) {
        int state = board[square + mult(inc, i)] & 0x00c00000;
        if(state == 0x00400000 || state == 0x00c00000) {
            return 0;
        }
    }
    return 1;
}

int square_in_configuration(int square) {
    for(int i = 0; i < 5; i++) {
        int inc = configuration[i] > 99 ? 10 : 1;
        int start = mod(configuration[i], 100);
        for(int j = 0; j < ship_sizes[i]; j++) {
            if(start + mult(inc,j) == square) {
                return 1;
            }
        }
    }
    return 0;
}

int calculate_overlap(int lower, int lower_square, int upper, int upper_square) {
    int lower_size = ship_sizes[lower];
    int upper_size = ship_sizes[upper];
    int inc_lower = (lower_square > 99) ? 10 : 1;
    int inc_upper = (upper_square > 99) ? 10 : 1;
    int lower_pos = mod(lower_square,100);
    int upper_pos = mod(upper_square,100);
    for(int i = 0; i < lower_size; i++) {
        for(int j = 0; j < upper_size; j++) {
            if(lower_pos + mult(inc_lower,i) == upper_pos + mult(inc_upper,j)) {
                return 0;
            }
        }
    }
    return 1;
}

int check_valid_configuration() {
    for(int i = 0; i < 100; i++) {
        if((board[i] & 0x00c00000) == 0x00800000) {
            if(!square_in_configuration(i)) {
                return 0;
            }
        }
    }
    send_accel_value(generate_acc_encoding(0, configuration[0], 1, configuration[1]));
    send_accel_value(generate_acc_encoding(2, configuration[2], 3, configuration[3]));
    send_accel_value(generate_acc_encoding(4, configuration[4], 5, 5));
    asm volatile ("sac a1");
    asm volatile ("lui a5,%hi(acc_result)");
    asm volatile ("sw a1,%lo(acc_result)(a5)");
    return acc_result;
}

int run_accelerator() {
    clear_accelerator_data();
    // Get all valid positions
    for(int ship = 0; ship < 5; ship++) {
        if(enemy_sunk[ship] != -1) {
            possible_positions[ship][enemy_sunk[ship]] = 1;
        } else {
            for(int v = 0; v < 2; v++) {
                for(int square = 0; square < 100; square++) {
                    if(check_valid_position(ship, square, v)) {
                        possible_positions[ship][mult(100,v) + square] = 1;
                    }
                }
            }
        }
    }
    // Evaluate configurations
    for(int accel_cnt = 0; accel_cnt < ACCELERATOR_COUNT; accel_cnt++) {
        // Generate configuration
        for(int ship = 0; ship < 5; ship++) {
            configuration[ship] = mod(rand(),200);
            if(!possible_positions[ship][configuration[ship]]) {
                ship--;
            }
        }
        // Check if configuration is legal (ACCELERATOR)
        if(!check_valid_configuration()) {
            accel_cnt--;
            continue;
        }
        // Mark positions
        for(int ship = 0; ship < 5; ship++) {
            int size = ship_sizes[ship];
            int pos = mod(configuration[ship],100);
            int inc = configuration[ship] >= 100 ? 10 : 1;
            for(int i = 0; i < size; i++) {
                if((board[pos + mult(inc,i)] & 0x00c00000) == 0) {
                    hit_counts[pos + mult(inc,i)]++;
                }
            }
        }
    }
    // Find max
    int max = -1;
    int target = 0;
    for(int i = 0; i < 100; i++) {
        if(hit_counts[i] > max) {
            max = hit_counts[i];
            target = i;
        }
    }
    return target;
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
    my_sunk[0] = 0;
    my_sunk[1] = 0;
    my_sunk[2] = 0;
    my_sunk[3] = 0;
    my_sunk[4] = 0;
    enemy_sunk[0] = -1;
    enemy_sunk[1] = -1;
    enemy_sunk[2] = -1;
    enemy_sunk[3] = -1;
    enemy_sunk[4] = -1;
    myTurn = 1;
    send_ppu_value(SET_MY_TURN);
    initialize_boards();
    for(int i = 0; i < 5; i++) {
        if(place_ship(mod(rand(), 100), i, rand() & 0x00000001) == 0) {
            i--;
        }
    }
    activeSquare = 55;
    board[activeSquare] |= SELECT_BIT;
    send_ppu_value(board[activeSquare]);
    ai_target = 55;
    ai_old_target = 55;
    acc_result = 0;
    ai_ran = 0;
    while(1) {
        ai_target = run_accelerator();
        ai_ran = 1;
        send_ppu_value(board[ai_old_target]);
        ai_old_target = ai_target;
        send_ppu_value(board[ai_target] | (((board[ai_target] & 0x00c00000) == 0) ? 1 << 14 : 0));
        while(ai_ran) {
            // Do nothing
        }
    }
}