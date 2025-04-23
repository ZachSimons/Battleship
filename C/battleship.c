#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#define BOARD_SIZE 10
#define NUM_SQUARES (BOARD_SIZE * BOARD_SIZE)
#define MAX_SHIPS 5

// Structure to store ship placement information
typedef struct {
    int x, y;
    bool vertical;
    int length;
} ShipPlacement;

// Board representation and tracking variables
bool board[BOARD_SIZE][BOARD_SIZE];
bool misses[BOARD_SIZE][BOARD_SIZE] = {false};
bool hits[BOARD_SIZE][BOARD_SIZE] = {false};
ShipPlacement possiblePlacements[MAX_SHIPS][NUM_SQUARES * 2];
int placementCounts[MAX_SHIPS] = {0};
bool incompatible[NUM_SQUARES * 2][NUM_SQUARES * 2] = {false};
int locationFrequencies[NUM_SQUARES * 2] = {0};
int squareFrequencies[NUM_SQUARES] = {0};
int validConfigurations = 0;

// Checks if a ship placement is valid based on board boundaries and misses
bool isValidPlacement(int x, int y, int length, bool vertical) {
    if (vertical) {
        if (y + length > BOARD_SIZE) return false;
    } else {
        if (x + length > BOARD_SIZE) return false;
    }
    for (int i = 0; i < length; i++) {
        int nx = vertical ? x : x + i;
        int ny = vertical ? y + i : y;
        if (misses[nx][ny] || hits[nx][ny]) return false;
    }
    return true;
}

// Generates all possible valid placements for a given ship
void generatePossiblePlacements(int shipIndex, int shipLength) {
    placementCounts[shipIndex] = 0;
    for (int x = 0; x < BOARD_SIZE; x++) {
        for (int y = 0; y < BOARD_SIZE; y++) {
            for (int vertical = 0; vertical < 2; vertical++) {
                if (isValidPlacement(x, y, shipLength, vertical)) {
                    ShipPlacement sp = {x, y, vertical, shipLength};
                    possiblePlacements[shipIndex][placementCounts[shipIndex]++] = sp;
                }
            }
        }
    }
}

// Finds the highest probability square
void findHighestProbabilitySquare(int *x, int *y) {
    float maxProb = -1.0;
    int bestIndex = -1;
    for (int i = 0; i < NUM_SQUARES; i++) {
        if (!hits[i % BOARD_SIZE][i / BOARD_SIZE] && squareFrequencies[i] > maxProb) {
            maxProb = squareFrequencies[i];
            bestIndex = i;
        }
    }
    if (bestIndex != -1) {
        *x = bestIndex % BOARD_SIZE;
        *y = bestIndex / BOARD_SIZE;
    } else {
        *x = 0;
        *y = 0;
    }
}

void printBoard() {
    printf("\nProbability Board:\n");
    for (int y = 0; y < BOARD_SIZE; y++) {
        for (int x = 0; x < BOARD_SIZE; x++) {
            if (misses[x][y]) {
                printf(" M  "); // Mark missed shots
            } else if (hits[x][y]) {
                printf(" H  "); // Mark hit shots
            } else {
                printf("%2d  ", squareFrequencies[y * BOARD_SIZE + x]); // Print probabilities
            }
        }
        printf("\n");
    }
}

void determineIncompatiblePlacements();
void runSimulations();
void computeSquareFrequencies();
// Main function to execute the battleship placement algorithm
int main() {
    int shipSizes[MAX_SHIPS] = {5, 4, 3, 3, 2};
    while (1) {
        for (int i = 0; i < MAX_SHIPS; i++) {
            generatePossiblePlacements(i, shipSizes[i]);
        }
        determineIncompatiblePlacements();
        runSimulations();
        computeSquareFrequencies();
        
        int targetX, targetY;
        findHighestProbabilitySquare(&targetX, &targetY);
        printBoard();
        printf("Targeting square: (%d, %d). Hit or miss? (h/m): ", targetX, targetY);
        char result;
        scanf(" %c", &result);
        
        if (result == 'm' && targetX >= 0 && targetX < BOARD_SIZE && targetY >= 0 && targetY < BOARD_SIZE) {
            misses[targetX][targetY] = true;
        } else if (result == 'h' && targetX >= 0 && targetX < BOARD_SIZE && targetY >= 0 && targetY < BOARD_SIZE) {
            hits[targetX][targetY] = true;
        }
    }
    return 0;
}
