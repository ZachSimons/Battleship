#define BOARD_SIZE 10
#define NUM_SQUARES (BOARD_SIZE * BOARD_SIZE)
#define MAX_SHIPS 5
#define TOTAL_SHIP_POSITIONS 200

#define EMPTY 0
#define MISS  1
#define HIT   2
#define SUNK  3

/* 
 * Interrupt num values 
 * 0-99 shooting at respective square
 * 100 ACK_MISS (last shot was a miss)
 * 101 ACK_HIT  (last shot was a hit)
 * {102, 103, 104, 105, 106} = {PS2_LEFT, PS2_UP, PS2_DOWN, PS2_RIGHT, PS2_ENTER}
 * > 106 = SHIP SUNK bit[15:8] = ship pos, bit[27:20] = ship type
 */
#define SINK_BIT 0x00800000
#define GET_ACK_SINK_SHIP(x) ((x & 0x00ff0000) >> 16)
#define SET_ACK_SINK_SHIP(x) ((x & 0x000000ff) << 16)
#define GET_ACK_SINK_POS(x) ((x & 0x0000ff00) >> 8)
#define SET_ACK_SINK_POS(x) ((x & 0x000000ff) << 8)
#define ACK_MISS 100
#define ACK_HIT  101
#define PS2_LEFT 102
#define PS2_UP 103
#define PS2_DOWN 104
#define PS2_RIGHT 105
#define PS2_ENTER 106
#define ACH_LOSE 107

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
#define SET_E_BIT(x) ((x & 0x00000001) << 22)
#define SET_M_BIT(x) ((x & 0x00000001) << 21)
#define SET_V_BIT(x) ((x & 0x00000001) << 20)
#define SET_TYPE(x) ((x & 0x00000007) << 17)
#define SET_SEG(x) ((x & 0x00000007) << 14)
#define SET_SEL_BIT(x) ((x & 0x00000001) << 23)

int mult(int, int);
int mod(int, int);
int rand();
int check_sinks();
int check_lose();

// Game data
int my_board[NUM_SQUARES];
int my_positions[MAX_SHIPS];
char target_board[NUM_SQUARES];
char ship_sizes[MAX_SHIPS];
int my_sunk[MAX_SHIPS];
int enemy_sunk[MAX_SHIPS];

int active_square;
int toSnd;
int ai_target;
int enemy_result;
int myTurn;

// Accelerator data
char possible_positions[MAX_SHIPS][TOTAL_SHIP_POSITIONS];
int hit_counts[NUM_SQUARES];
#define ACCELERATOR_COUNT 8000

void entry_point() {
    asm volatile ("j main");
    asm volatile ("ldi a0");
    asm volatile ("call exception_handler");
    asm volatile ("rti");
}

void exception_handler(unsigned int num) {
    if(num < 100) {
        my_board[num] |= SET_M_BIT(1);
        toSnd = my_board[num];
        asm volatile ("lw a1,0(toSnd)");
        asm volatile ("snd a1");
        if(check_lose()) {
            asm volatile ("addi a0,zero,107");
            asm volatile ("snd a0");
            asm volatile ("jmp EXIT");
        } else if(GET_E_BIT(my_board[num])) {
            if(check_sinks()) {
                toSnd = SINK_BIT | SET_ACK_SINK_SHIP(GET_TYPE(my_board[num])) | my_positions[GET_TYPE(my_board[num])];
                asm volatile ("lui a0,%hi(toSnd)");
                asm volatile ("lw a0,%lo(toSnd)(a0)");
                asm volatile ("snd a0");
            } else {
                asm volatile ("addi a0,zero,101");
                asm volatile ("snd a0");
            }
        } else {
            asm volatile ("addi a0,zero,100");
            asm volatile ("snd a0");
        }
        myTurn = 1;
    } else if(num == ACK_MISS) {
        target_board[active_square] = MISS;
        asm volatile ("la a0,PRE_ACCELERATOR_LABEL");
        asm volatile ("rsi a0");
    } else if(num == ACK_HIT) {
        target_board[active_square] = HIT;
        asm volatile ("la a0,PRE_ACCELERATOR_LABEL");
        asm volatile ("rsi a0");
    } else if(num == PS2_LEFT) {
        if(mod(active_square, 10)) {
            my_board[active_square] &= ~SET_SEL_BIT(1);
            toSnd = my_board[active_square];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
            active_square--;
            my_board[active_square] |= SET_SEL_BIT(1);
            toSnd = my_board[active_square];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
        }
    } else if(num == PS2_UP) {
        if(active_square > 9) {
            my_board[active_square] &= ~SET_SEL_BIT(1);
            toSnd = my_board[active_square];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
            active_square -= 10;
            my_board[active_square] |= SET_SEL_BIT(1);
            toSnd = my_board[active_square];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
        }
    } else if(num == PS2_DOWN) {
        if(active_square , 90) {
            my_board[active_square] &= ~SET_SEL_BIT(1);
            toSnd = my_board[active_square];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
            active_square += 10;
            my_board[active_square] |= SET_SEL_BIT(1);
            toSnd = my_board[active_square];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
        }
    } else if(num == PS2_RIGHT) {
        if(mod(active_square, 10) != 9) {
            my_board[active_square] &= ~SET_SEL_BIT(1);
            toSnd = my_board[active_square];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
            active_square++;
            my_board[active_square] |= SET_SEL_BIT(1);
            toSnd = my_board[active_square];
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("ugs a0");
        }
    } else if(num == PS2_ENTER) {
        if(myTurn) {
            asm volatile ("lui a0,%hi(toSnd)");
            asm volatile ("lw a0,%lo(toSnd)(a0)");
            asm volatile ("snd a0");
            myTurn = 0;
        }
    } else { // ACK_HIT + SINK
        int pos = GET_ACK_SINK_POS(num);
        int inc = pos > 99 ? 10 : 1;
        int square = mod(pos, 100);
        int ship = GET_ACK_SINK_SHIP(num);
        for(int i = 0; i < ship_sizes[ship]; i++) {
            target_board[pos + mult(inc, i)] = SUNK;
        }
        enemy_sunk[ship] = pos;
        asm volatile ("la a0,PRE_ACCELERATOR_LABEL");
        asm volatile ("rsi a0");
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
    asm volatile ("ldr a0");
    return a;
}

void clear_boards() {
    for(int i = 0; i < NUM_SQUARES; i++) {
        my_board[i] = SET_SHIP_POS(i);
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
        int pos = square + mult(inc,i);
        my_board[pos] = SET_SHIP_POS(pos) | SET_TYPE(type) | SET_E_BIT(1) | SET_V_BIT(v) | SET_SEG(i);
        toSnd = my_board[pos];
        asm volatile ("lui a0,%hi(toSnd)");
        asm volatile ("lw a0,%lo(toSnd)(a0)");
        asm volatile ("ugs a0");
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

void clear_hit_counts() {
    for(int i = 0; i < NUM_SQUARES; i++) {
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

int calculate_overlap(int lower, int lower_square, int upper, int upper_square) {
    int lower_size = ship_sizes[lower];
    int upper_size = ship_sizes[upper];
    int inc_lower = (lower_square > 99) ? 10 : 1;
    int inc_upper = (upper_square > 99) ? 10 : 1;
    int lower_pos = mod(lower_square,100);
    int upper_pos = mod(upper_square,100);
    for(int i = 0; i < lower_size; i++) {
        for(int j = 0; j < upper_size; j++) {
            if(lower_pos + mult(i,inc_lower) == upper_pos + mult(j,inc_upper)) {
                return 0;
            }
        }
    }
    return 1;
}

int check_valid_configuration(unsigned char* configuration) {
    for(int i = 0; i < NUM_SQUARES; i++) {
        if(target_board[i] == HIT) {
            if(!square_in_configuration(configuration, i)) {
                return 0;
            }
        }
    }
    for(int i = 0; i < MAX_SHIPS-1; i++) {
        for(int j = i+1; j < MAX_SHIPS; j++) {
            if(!calculate_overlap(i, configuration[i], j, configuration[j])) {
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
    // Evaluate configurations
    for(int accel_cnt = 0; accel_cnt < ACCELERATOR_COUNT; accel_cnt++) {
        unsigned char ship_configuration[5];
        // Generate configuration
        for(int ship = 0; ship < MAX_SHIPS; ship++) {
            ship_configuration[ship] = mod(rand(),200);
            if(!possible_positions[ship][ship_configuration[ship]]) {
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
        ship_sizes[0] = 2;
        ship_sizes[1] = 3;
        ship_sizes[2] = 3;
        ship_sizes[3] = 4;
        ship_sizes[4] = 5;
        my_sunk[0] = -1;
        my_sunk[1] = -1;
        my_sunk[2] = -1;
        my_sunk[3] = -1;
        my_sunk[4] = -1;
        enemy_sunk[0] = -1;
        enemy_sunk[1] = -1;
        enemy_sunk[2] = -1;
        enemy_sunk[3] = -1;
        enemy_sunk[4] = -1;
        active_square = 55;
        myTurn = 1;
        clear_boards();
        for(int i = 0; i < 5; i++) {
            while(!place_ship(mod(rand(),100), mod(rand(),2), i)) {
                // Do nothing
            }
        }
        while(1) {
            asm volatile ("PRE_ACCELERATOR_LABEL:");
            ai_target = run_accelerator();
            // TODO: UGS WITH AI RESULT
            asm volatile ("ugs ai_target, AI");
            asm volatile ("STALL_LOOP_LABEL:");
            while(1) {} // Stall for interrupt
            asm volatile ("FIRE_RESULT_LABEL:");
            if(enemy_result) {
                target_board[active_square] = HIT;
            } else {
                target_board[active_square] = MISS;
            }
        }
    }
}