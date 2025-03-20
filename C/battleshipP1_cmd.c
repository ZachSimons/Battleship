#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define BOARD_SIZE 10
#define NUM_SQUARES (BOARD_SIZE * BOARD_SIZE)
#define MAX_SHIPS 5

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

int my_board[NUM_SQUARES];
int enemy_board[NUM_SQUARES];
char ship_sizes[MAX_SHIPS] = {2, 3, 3, 4, 5};
char ship_letter[MAX_SHIPS] = {'d', 's', 'c', 'b', 'a'};

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
        if (((square+1)%10) + inc*size > 10) {
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

void print_board(int board) {
    if(board) {
        printf("______________Enemy Board______________\n");
    } else {
        printf("________________My Board_______________\n");
    }
    for(int i = 0; i < BOARD_SIZE; i++) {
        for(int j = 0; j < BOARD_SIZE; j++) {
            if(board) {
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

int main() {
    srand(time(NULL));
    for(int i = 0; i < 10; i++) {
        while(!place_ship(i%2, rand() % 100, rand()%2, i/2)) {
            // Do nothing
        }
    }
    int turn = 1;
    int guess;
    while(1) {
        print_board(0);
        print_board(1);
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