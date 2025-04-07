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
int guess = 0;

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
            my_board[square + inc*i] |= SET_TYPE(type) | SET_E_BIT(1) | SET_V_BIT(v) | SET_SEG(i);
        } else {
            enemy_board[square + inc*i] |= SET_TYPE(type) | SET_E_BIT(1) | SET_V_BIT(v) | SET_SEG(i);
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
            if(GET_E_BIT(enemy_board[i])) {
                return 0;
            }
        }
    }
    return 1;
}

// Interrupt handler
void interrupt_handler(int rsi) {
    // read
    if(rsi > (100 << 1)) {
        // PS2
        if(rsi == 'w') {
            if(guess > 9) {
                guess -= 10;
            }
        } else if(rsi == 'a') {
            if(guess % 10 != 0) {
                guess -= 1;
            }
        } else if(rsi == 's') {
            if(guess < 90) {
                guess += 10;
            }
        } else if(rsi == 'd') {
            if(guess % 10 != 9) {
                guess += 1;
            }
        } else {
            // snd guess
        }
    } else {
        // Ethernet
    }
}

int main() {
    for(int i = 0; i < 5; i++) {
        int pos = rand() % 100;
        int v = rand() % 2;
        while(!place_ship(i, pos, v, i)) {
            pos = rand() % 100;
            v = rand() % 2;
        }
    }
    while(1) {
        // Run Accelerator
    }
}