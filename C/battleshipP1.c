#include <stdio.h>

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
char ship_sizes = {2, 3, 3, 4, 5};
char ship_letter = {''}

void clear_board() {
    for(int i = 0; i < NUM_SQUARES; i++) {
        my_board[i] = 0;
        enemy_board[i] = 0;
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
            my_board[square] = SET_TYPE(type) | SET_E_BIT(1) | SET_V_BIT(v) | SET_SEG(i);
        } else {
            enemy_board[square] = SET_TYPE(type) | SET_E_BIT(1) | SET_V_BIT(v) | SET_SEG(i);
        }
    }
}

void print_board(int board) {
    for(int i = 0; i < NUM_SQUARES; i++) {
        for(int j = 0; j < BOARD_SIZE; j++) {
            if(board) {
                if(GET_E_BIT(my_board[i*10 + j])) {
                    int type = GET_TYPE(my_board[i*10 + j]);
                    if(type())
                } else {
                    if(GET_M_BIT(my_board[i*10 + j])) {
                        printf("|.O|");
                    } else {
                        printf("|..|");
                    }
                }
            } else {

            }
        }
    }
}

int main() {
    int test = SET_BOARD_SEL(0) | SET_SHIP_POS(22) | SET_SEL_BIT(0) | SET_E_BIT(1) | SET_M_BIT(0) | SET_V_BIT(0) | SET_TYPE(3) | SET_SEG(4);
    printf("%d\n", test);
    printf("%d\n", GET_BOARD_SEL(test));
    printf("%d\n", GET_SHIP_POS(test));
    printf("%d\n", GET_SEL_BIT(test));
    printf("%d\n", GET_E_BIT(test));
    printf("%d\n", GET_M_BIT(test));
    printf("%d\n", GET_V_BIT(test));
    printf("%d\n", GET_TYPE(test));
    printf("%d\n", GET_SEG(test));
}