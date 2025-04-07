#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define BOARD_SIZE 10
#define NUM_SQUARES (BOARD_SIZE * BOARD_SIZE)
#define MAX_SHIPS 5
#define TOTAL_SHIP_POSITIONS 200

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

// Game data
int my_board[NUM_SQUARES];
int enemy_board[NUM_SQUARES];
char ship_sizes[MAX_SHIPS] = {2, 3, 3, 4, 5};
char ship_letter[MAX_SHIPS] = {'d', 's', 'c', 'b', 'a'};

// Accelerator data
char possible_positions[MAX_SHIPS][TOTAL_SHIP_POSITIONS];
char invalid_combos[MAX_SHIPS][TOTAL_SHIP_POSITIONS][MAX_SHIPS-1][TOTAL_SHIP_POSITIONS];
int hit_counts[NUM_SQUARES];
#define ACCELERATOR_COUNT 2000

void clear_board(int board) {
    for(int i = 0; i < NUM_SQUARES; i++) {
        if(board) {
            my_board[i] = 0;
        } else {
            enemy_board[i] = 0;
        }
    }
}

int place_ship(int board, int square, int v, int type) {
    int size = ship_sizes[type];
    int inc = v ? 10 : 1;
    if(v) {
        if(square + inc*size > 99) {
            return 0;
        }
    } else {
        if ((square%10) + inc*size > 10) {
            return 0;
        }
    }
    for(int i = 0; i < size; i++) {
        if(board) {
            if(GET_E_BIT(my_board[square + inc*i])) {
                return 0;
            }
        } else {
            if(GET_E_BIT(enemy_board[square + inc*i])) {
                return 0;
            }
        }
    }
    for(int i = 0; i < size; i++) {
        if(board) {
            my_board[square + inc*i] = SET_TYPE(type) | SET_E_BIT(1) | SET_V_BIT(v) | SET_SEG(i);
        } else {
            enemy_board[square + inc*i] = SET_TYPE(type) | SET_E_BIT(1) | SET_V_BIT(v) | SET_SEG(i);
        }
    }
    return 1;
}

int check_win(int board) {
    for(int i = 0; i < NUM_SQUARES; i++) {
        if(board) {
            if(GET_E_BIT(my_board[i]) && !GET_M_BIT(my_board[i])) {
                return 0;
            }
        } else {
            if(GET_E_BIT(enemy_board[i]) && !GET_M_BIT(enemy_board[i])) {
                return 0;
            }
        }
    }
    return 1;
}

void print_board(int board, int turn, int target) {
    if(board) {
        printf("______________Enemy Board______________\n");
    } else {
        printf("________________My Board_______________\n");
    }
    for(int i = 0; i < BOARD_SIZE; i++) {
        for(int j = 0; j < BOARD_SIZE; j++) {
            if(board == turn && target == i*BOARD_SIZE + j) {
                printf("|AI|");
            } else if(board) {
                if(GET_E_BIT(my_board[i*10 + j])) {
                    int type = GET_TYPE(my_board[i*10 + j]);
                    printf("|%c", ship_letter[type]);
                    if(GET_M_BIT(my_board[i*10 + j])) {
                        printf("0|");
                    } else {
                        printf(".|");
                    }
                } else {
                    if(GET_M_BIT(my_board[i*10 + j])) {
                        printf("|.O|");
                    } else {
                        printf("|..|");
                    }
                }
            } else {
                if(GET_E_BIT(enemy_board[i*10 + j])) {
                    int type = GET_TYPE(enemy_board[i*10 + j]);
                    printf("|%c", ship_letter[type]);
                    if(GET_M_BIT(enemy_board[i*10 + j])) {
                        printf("0|");
                    } else {
                        printf(".|");
                    }
                } else {
                    if(GET_M_BIT(enemy_board[i*10 + j])) {
                        printf("|.O|");
                    } else {
                        printf("|..|");
                    }
                }

            }
        }
        printf("\n");
    }
    printf("_______________________________________\n");
}

void clear_possible_positions() {
    for(int ship = 0; ship < MAX_SHIPS; ship++) {
        for(int v = 0; v < 2; v++) {
            for(int square = 0; square < NUM_SQUARES; square++) {
                possible_positions[ship][v*100 + square] = 0;
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
                            invalid_combos[lower][lower_v*100 + lower_pos][upper][upper_v*100 + upper_pos] = 0;
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

int check_valid_position(int turn, int ship, int square, int v) {
    int size = ship_sizes[ship];
    int inc = v ? 10 : 1;
    if(v) {
        if(square + inc*size > 99) {
            return 0;
        }
    } else {
        if (((square+1)%10) + inc*size > 10) {
            return 0;
        }
    }
    for(int i = 0; i < size; i++) {
        if(turn) {
            if(GET_E_BIT(my_board[square + inc*i])) {
                return 0;
            }
        } else {
            if(GET_E_BIT(enemy_board[square + inc*i])) {
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
            if(lower_pos + i*inc_lower == upper_pos + j*inc_upper) {
                return 0;
            }
        }
    }
    return 1;
}

int run_accelerator(int turn) {
    clear_accelerator_data();
    // Get all valid positions
    for(int ship = 0; ship < MAX_SHIPS; ship++) {
        for(int v = 0; v < 2; v++) {
            for(int square = 0; square < NUM_SQUARES; square++) {
                if(check_valid_position(turn, ship, square, v)) {
                    possible_positions[ship][v*100 + square] = 1;
                }
            }
        }
    }
    // Calculate invalid combos
    for(int lower = 0; lower < MAX_SHIPS - 1; lower++) {
        for(int lower_v = 0; lower_v < 2; lower_v++) {
            for(int lower_pos = 0; lower_pos < NUM_SQUARES; lower_pos++) {
                if(possible_positions[lower][lower_v*100 + lower_pos]) {
                    for(int upper = lower + 1; upper < MAX_SHIPS; upper++) {
                        for(int upper_v = 0; upper_v < 2; upper_v++) {
                            for(int upper_pos = 0; upper_pos < NUM_SQUARES; upper_pos++) {
                                invalid_combos[lower][lower_v*100 + lower_pos][upper][upper_v*100 + upper_pos] = calculate_overlap(lower, lower_pos, lower_v, upper, upper_pos, upper_v);
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
            while(1) {
                ship_configuration[ship] = rand() % 200;
                if(possible_positions[ship][ship_configuration[ship]]) {
                    int valid = 1;
                    for(int lower = 0; lower < ship; lower++) {
                        if(!invalid_combos[lower][ship_configuration[lower]][ship][ship_configuration[ship]]) {
                            valid = 0;
                            break;
                        }
                    }
                    if(valid) break;
                }
            }
        }
        // Check if configuration is legal (ACCELERATOR)
        // Mark positions
        for(int ship = 0; ship < MAX_SHIPS; ship++) {
            int size = ship_sizes[ship];
            int pos = ship_configuration[ship] - 100;
            int inc = ship_configuration[ship] >= 100 ? 10 : 1;
            for(int i = 0; i < size; i++) {
                hit_counts[pos + inc*i]++;
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

int main() {
    srand(time(NULL));
    for(int i = 0; i < 10; i++) {
        while(!place_ship(i%2, rand() % 100, rand()%2, i/2)) {
            // Do nothing
        }
    }
    int turn = 1;
    int target;
    int guess;
    while(1) {
        target = run_accelerator(!turn);
        print_board(0, !turn, target);
        print_board(1, !turn, target);
        printf("AI guess: %d\n", target);
        scanf("%d", &guess);
        if(turn) {
            enemy_board[guess] |= SET_M_BIT(1);
        } else {
            my_board[guess] |= SET_M_BIT(1);
        }
        turn = (turn+1)%2;
        if(check_win(turn)) {
            if(turn) {
                printf("Enemy wins!\n");
            } else {
                printf("You win!\n");
            }
            break;
        }
    }
}