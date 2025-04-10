#define BOARD_SIZE 10
#define NUM_SQUARES (BOARD_SIZE * BOARD_SIZE)
#define MAX_SHIPS 5
#define TOTAL_SHIP_POSITIONS 200

#define EMPTY 0
#define MISS  1
#define HIT   2
#define SUNK  3

#define ACK_MISS 100
#define ACK_HIT  101
#define ACK_SINK_BIT 0x000fffff
#define GET_ACK_SINK_SHIP(x) ((x & 0x0ff00000) >> 20)
#define SET_ACK_SINK_SHIP(x) ((x & 0x000000ff) << 20)
#define PS2_LEFT 1
#define PS2_UP 1
#define PS2_DOWN 1
#define PS2_RIGHT 1
#define PS2_ENTER 1

#define GET_BOARD_SEL(x) (x >> 31)
#define GET_SHIP_POS(x) ((x & 0x7f000000) >> 24)
#define GET_SEL_BIT(x) ((x & 0x00800000) >> 23)
#define GET_E_BIT(x) ((x & 0x00400000) >> 22)
#define GET_M_BIT(x) ((x & 0x00200000) >> 21)
#define GET_V_BIT(x) ((x & 0x00100000) >> 20)
#define GET_TYPE(x) ((x & 0x000e0000) >> 17)
#define GET_SEG(x) ((x & 0x0001c000) >> 14)
#define SET_BOARD_SEL(x) (x << 31)
#define SET_SHIP_POS(x) ((x & 0x0000007f) << 24)
#define SET_SEL_BIT(x) ((x & 0x00000001) << 23)
#define SET_E_BIT(x) ((x & 0x00000001) << 22)
#define SET_M_BIT(x) ((x & 0x00000001) << 21)
#define SET_V_BIT(x) ((x & 0x00000001) << 20)
#define SET_TYPE(x) ((x & 0x00000007) << 17)
#define SET_SEG(x) ((x & 0x00000007) << 14)

int mult(int, int);
int mod(int, int);
int rand();
int check_sinks();
int check_lose();

// Game data
int my_board[NUM_SQUARES];
int my_positions[MAX_SHIPS];
char target_board[NUM_SQUARES];
char ship_sizes[MAX_SHIPS] = {2, 3, 3, 4, 5};
int my_sunk[MAX_SHIPS] = {-1, -1, -1, -1, -1};
int enemy_sunk[MAX_SHIPS] = {-1, -1, -1, -1, -1};

int active_square;
int ai_target;
int enemy_result;

// Accelerator data
char possible_positions[MAX_SHIPS][TOTAL_SHIP_POSITIONS];
char invalid_combos[MAX_SHIPS][TOTAL_SHIP_POSITIONS][MAX_SHIPS][TOTAL_SHIP_POSITIONS];
int hit_counts[NUM_SQUARES];
#define ACCELERATOR_COUNT 8000

void entry_point() {
    asm volatile ("j main");
    asm volatile ("ldi a0");
    asm volatile ("call exception_handler");
}

void exception_handler(int num) {
    if(num < 100) {
        my_board[num] |= SET_M_BIT(1);
        if(check_lose()) {
            asm volatile ("snd lose");
        } else if(GET_E_BIT(my_board[num])) {
            if(check_sinks()) {
                int resp = SET_ACK_SINK_SHIP(GET_TYPE(my_board[num])) | my_positions[GET_TYPE(my_board[num])];
                asm volatile ("snd resp");
            }
            asm volatile ("snd ACK_HIT");
        } else {
            asm volatile ("snd ACK_MISS");
        }
    } else if(num == ACK_MISS) {
        target_board[active_square] = MISS;
    } else if(num == ACK_HIT) {
        target_board[active_square] = HIT;
    } else if(num == PS2_LEFT) {
        if(mod(active_square, 10)) {
            active_square--;
        }
    } else if(num == PS2_UP) {
        if(active_square > 9) {
            active_square -= 10;
        }
    } else if(num == PS2_DOWN) {
        if(active_square , 90) {
            active_square += 10;
        }
    } else if(num == PS2_RIGHT) {
        if(mod(active_square, 10) != 9) {
            active_square++;
        }
    } else if(num == PS2_ENTER) {
        asm volatile ("snd active_square");
    } else { // ACK_HIT + SINK
        int pos = ACK_SINK_BIT & num;
        int inc = pos > 99 ? 10 : 1;
        int square = mod(pos, 100);
        int ship = GET_ACK_SINK_SHIP(num);
        for(int i = 0; i < ship_sizes[ship]; i++) {
            target_board[pos + mult(inc, i)] = SUNK;
        }
        enemy_sunk[ship] = pos;
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

int rand() {
    int a = 10;
    asm volatile ("ldr into whatever is above!");
    return a;
}

void clear_boards() {
    for(int i = 0; i < NUM_SQUARES; i++) {
        my_board[i] = 0;
        target_board[i] = 0;
    }
}

int place_ship(int square, int v, int type) {
    int size = ship_sizes[type];
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
        if(GET_E_BIT(my_board[square + mult(inc,i)])) {
            return 0;
        }
    }
    for(int i = 0; i < size; i++) {
        my_board[square + mult(inc,i)] = SET_TYPE(type) | SET_E_BIT(1) | SET_V_BIT(v) | SET_SEG(i);
    }
    my_positions[type] = square + mult(100,v);
    return 1;
}

int check_lose() {
    for(int i = 0; i < MAX_SHIPS; i++) {
        if(my_sunk[i] == -1) {
            return 0;
        }
    }
    return 1;
}

void clear_possible_positions() {
    for(int ship = 0; ship < MAX_SHIPS; ship++) {
        for(int v = 0; v < 2; v++) {
            for(int square = 0; square < NUM_SQUARES; square++) {
                possible_positions[ship][mult(v,100) + square] = 0;
            }
        }
    }
}

void clear_invalid_combos() {
    for(int lower = 0; lower < MAX_SHIPS - 1; lower++) {
        for(int lower_v = 0; lower_v < 2; lower_v++) {
            for(int lower_pos = 0; lower_pos < NUM_SQUARES; lower_pos++) {
                for(int upper = lower + 1; upper < MAX_SHIPS; upper++) {
                    for(int upper_v = 0; upper_v < 2; upper_v++) {
                        for(int upper_pos = 0; upper_pos < NUM_SQUARES; upper_pos++) {
                            invalid_combos[lower][mult(lower_v,100) + lower_pos][upper][mult(upper_v,100) + upper_pos] = 0;
                        }
                    }
                }
            }
        }
    }
}

void clear_hit_counts() {
    for(int i = 0; i < NUM_SQUARES; i++) {
        hit_counts[i] = 0;
    }
}

void clear_accelerator_data() {
    clear_possible_positions();
    clear_invalid_combos();
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
        if(target_board[square + mult(inc,i)] == MISS || target_board[square + mult(inc,i)] == SUNK) {
            return 0;
        }
    }
    return 1;
}

int square_in_configuration(unsigned char* configuration, int square) {
    for(int i = 0; i < MAX_SHIPS; i++) {
        int inc = configuration[i] >= 100 ? 10 : 1;
        int start = mod(configuration[i], 100);
        for(int j = 0; j < ship_sizes[i]; j++) {
            if(start + mult(inc,j) == square) {
                return 1;
            }
        }
    }
    return 0;
}

int check_valid_configuration(unsigned char* configuration) {
    for(int i = 0; i < NUM_SQUARES; i++) {
        if(target_board[i] == HIT) {
            if(!square_in_configuration(configuration, i)) {
                return 0;
            }
        }
    }
    return 1;
}

int calculate_overlap(int lower, int lower_pos, int lower_v, int upper, int upper_pos, int upper_v) {
    int lower_size = ship_sizes[lower];
    int upper_size = ship_sizes[upper];
    int inc_lower = lower_v ? 10 : 1;
    int inc_upper = upper_v ? 10 : 1;
    for(int i = 0; i < lower_size; i++) {
        for(int j = 0; j < upper_size; j++) {
            if(lower_pos + mult(i,inc_lower) == upper_pos + mult(j,inc_upper)) {
                return 0;
            }
        }
    }
    return 1;
}

int run_accelerator() {
    clear_accelerator_data();
    // Get all valid positions
    for(int ship = 0; ship < MAX_SHIPS; ship++) {
        if(enemy_sunk[ship] != -1) {
            possible_positions[ship][enemy_sunk[ship]] = 1;
        } else {
            for(int v = 0; v < 2; v++) {
                for(int square = 0; square < NUM_SQUARES; square++) {
                    if(check_valid_position(ship, square, v)) {
                        possible_positions[ship][mult(v,100) + square] = 1;
                    }
                }
            }
        }
    }
    // Calculate invalid combos
    for(int lower = 0; lower < MAX_SHIPS - 1; lower++) {
        for(int lower_v = 0; lower_v < 2; lower_v++) {
            for(int lower_pos = 0; lower_pos < NUM_SQUARES; lower_pos++) {
                if(possible_positions[lower][mult(lower_v,100) + lower_pos]) {
                    for(int upper = lower + 1; upper < MAX_SHIPS; upper++) {
                        for(int upper_v = 0; upper_v < 2; upper_v++) {
                            for(int upper_pos = 0; upper_pos < NUM_SQUARES; upper_pos++) {
                                invalid_combos[lower][mult(lower_v,100) + lower_pos][upper][mult(upper_v,100) + upper_pos] = calculate_overlap(lower, lower_pos, lower_v, upper, upper_pos, upper_v);
                            }
                        }
                    }
                }
            }
        }
    }
    // Evaluate configurations
    for(int accel_cnt = 0; accel_cnt < ACCELERATOR_COUNT; accel_cnt++) {
        unsigned char ship_configuration[5];
        // Generate configuration
        for(int ship = 0; ship < MAX_SHIPS; ship++) {
            ship_configuration[ship] = mod(rand(),200);
            if(possible_positions[ship][ship_configuration[ship]]) {
                int valid = 1;
                for(int lower = 0; lower < ship; lower++) {
                    if(!invalid_combos[lower][ship_configuration[lower]][ship][ship_configuration[ship]]) {
                        ship = 0;
                        break;
                    }
                }
            } else {
                ship--;
            }
        }
        // Check if configuration is legal (ACCELERATOR)
        if(!check_valid_configuration(ship_configuration)) {
            accel_cnt--;
            continue;
        }
        // Mark positions
        for(int ship = 0; ship < MAX_SHIPS; ship++) {
            char size = ship_sizes[ship];
            unsigned char pos = mod(ship_configuration[ship],100);
            unsigned char inc = ship_configuration[ship] >= 100 ? 10 : 1;
            for(int i = 0; i < size; i++) {
                if(target_board[pos + mult(inc,i)] == EMPTY) {
                    hit_counts[pos + mult(inc,i)]++;
                }
            }
        }
    }
    // Find max
    int max = -1;
    int target = 0;
    for(int i = 0; i < NUM_SQUARES; i++) {
        if(hit_counts[i] > max) {
            max = hit_counts[i];
            target = i;
        }
    }
    return target;
}

int check_sinks() {
    for(int i = 0; i < MAX_SHIPS; i++) {
        if(my_sunk[i] == -1) {
            int isSunk = 1;
            int inc = my_positions[i] > 99 ? 10 : 1;
            int pos = mod(my_positions[i],100);
            for(int j = 0; j < ship_sizes[i]; j++) {
                if(!GET_M_BIT(my_board[pos + mult(inc,j)])) {
                    isSunk = 0;
                }
            }
            if(isSunk) {
                my_sunk[i] = my_positions[i];
                return 1;
            }
        }
    }
    return 0;
}

int main() {
    while(1) {
        active_square = 55;
        clear_boards();
        for(int i = 0; i < 5; i++) {
            while(!place_ship(mod(rand(),100), mod(rand(),2), i)) {
                // Do nothing
            }
        }
        while(1) {
            asm volatile ("PRE ACCELERATOR LABEL");
            ai_target = run_accelerator();
            asm volatile ("ugs ai_target, AI");
            asm volatile ("STALL LOOP LABEL");
            while(1) {} // Stall for interrupt
            asm volatile ("FIRE RESULT LABEL");
            if(enemy_result) {
                target_board[active_square] = HIT;
            } else {
                target_board[active_square] = MISS;
            }
        }
    }
}