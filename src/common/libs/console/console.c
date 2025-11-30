/* --------------- Includes ---------------- */

#include "console.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

uint16_t globalX;
uint16_t globalY;

/* -------- Function Implementations ------- */

const uint8_t font_data[ASCII_CHAR_COUNT][FONT_HEIGHT] = {
    {0x00, 0x7C, 0x36, 0x36, 0x36, 0x36, 0x7C, 0x00}, // 'B'
    {0x00, 0x3C, 0x60, 0x62, 0x6A, 0x6A, 0x3A, 0x00}, // 'G'
    {0x00, 0x3C, 0x66, 0x66, 0x66, 0x66, 0x3C, 0x00}, // 'O'
    {0x00, 0x3C, 0x66, 0x02, 0x3A, 0x62, 0x3C, 0x00}, // 'a'
    {0x00, 0x60, 0x60, 0x7C, 0x66, 0x66, 0x7C, 0x00}, // 'b'
    {0x00, 0x00, 0x3C, 0x60, 0x60, 0x60, 0x3C, 0x00}, // 'c'
    {0x00, 0x06, 0x06, 0x3E, 0x66, 0x66, 0x3E, 0x00}, // 'd'
    {0x00, 0x00, 0x3C, 0x66, 0x7E, 0x60, 0x3C, 0x00}, // 'e'
    {0x00, 0x60, 0x60, 0x6C, 0x78, 0x6C, 0x66, 0x00}, // 'k'
    {0x00, 0x38, 0x18, 0x18, 0x18, 0x18, 0x3C, 0x00}, // 'l'
    {0x00, 0x00, 0x3C, 0x66, 0x66, 0x66, 0x3C, 0x00}, // 'o'
    {0x00, 0x00, 0x78, 0x6C, 0x60, 0x60, 0x60, 0x00}, // 'r'
    {0x00, 0x00, 0x3E, 0x60, 0x3C, 0x06, 0x7E, 0x00}, // 's'
    {0x00, 0x18, 0x18, 0x7E, 0x18, 0x18, 0x38, 0x00}, // 't'
    {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00} // ' '
};

void console_init() {
    globalX = 0;
    globalY = 0;
}

void print_string(uint16_t x, uint16_t y, VgaColours colour, const char* str, uint8_t strSize) {
    uint32_t string_width = strSize * FONT_WIDTH;
    uint16_t current_x = x;

    // Calculate the horizontal offset to center the string
    uint32_t x_offset = (VGA_SCREEN_WIDTH - string_width) / 2;

    // Adjust the starting x coordinate
    current_x = x_offset;

    for (uint32_t i = 0 ; i < strSize ; i++) {
        print_char(current_x, y, colour, str[i]);
        current_x += FONT_WIDTH; // Move to the next character position
    }
}

void print_hex(uint32_t n) {
    char hex_char;
    // Flag to ensure leading zeros are suppressed, but '0' is printed for input 0.
    bool printed_digit = FALSE;

    for (uint8_t i = 7; i > 0; i--) {
        uint8_t shift_amount = i * 4;
        uint8_t nibble_value = (n >> shift_amount) & 0xF;

        if (printed_digit || (nibble_value != 0) || (i == 0)) {
            printed_digit = TRUE;

            if (nibble_value <= 9) {
                hex_char = '0' + nibble_value;
            } else {
                hex_char = 'A' + (nibble_value - 10);
            }

            print_char(globalX, globalY, DEFAULT_COLOUR, hex_char);
        }
    }
}

void print_char(uint16_t x, uint16_t y, VgaColours colour, char c) {
    uint32_t char_index;

    switch (c) {
        case 'B':
            char_index = 0;
            break;
        case 'G':
            char_index = 1;
            break;
        case 'O':
            char_index = 2;
            break;
        case 'a':
            char_index = 3;
            break;
        case 'b':
            char_index = 4;
            break;
        case 'c':
            char_index = 5;
            break;
        case 'd':
            char_index = 6;
            break;
        case 'e':
            char_index = 7;
            break;
        case 'k':
            char_index = 8;
            break;
        case 'l':
            char_index = 9;
            break;
        case 'o':
            char_index = 10;
            break;
        case 'r':
            char_index = 11;
            break;
        case 's':
            char_index = 12;
            break;
        case 't':
            char_index = 13;
            break;
        default:
            char_index = 14;
    }

    const uint8_t *char_data = font_data[char_index];

    // Iterate through each row of the character
    for (int row = 0 ; row < FONT_HEIGHT ; row++) {
        uint8_t row_data = char_data[row];
        // Iterate through each bit (pixel) in the row
        for (int col = 0 ; col < FONT_WIDTH ; col++) {
            // Check if the bit is set (i.e., the pixel should be drawn)
            if ((row_data >> (7 - col)) & 1) {
                vga_draw_pixel(x + col, y + row, colour);
            }
        }
    }
}
