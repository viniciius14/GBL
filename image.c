void draw_string(unsigned short x, unsigned short y, unsigned char color, const char* str);
#define IMAGE_SIZE 1015
#define SCREEN_WIDTH    320
#define SCREEN_HEIGHT   200

#define LOGO_RESOLUTION_W 182
#define LOGO_RESOLUTION_H 132

#define SCREEN_SIZE     (SCREEN_WIDTH * SCREEN_HEIGHT)

/* VGA control port addresses */
#define PALETTE_MASK    0x3C6
#define PALETTE_READ    0x3C7
#define PALETTE_WRITE   0x3C8
#define PALETTE_DATA    0x3C9

#define VC_BLACK        0x00
#define VC_RED          0xE0
#define VC_GREEN        0x1C
#define VC_YELLOW       0xFC
#define VC_PINK         0xE3
#define VC_CYAN         0x1F
#define VC_L_GREY       0x6D
#define VC_WHITE        0xFF
#define LOGO_STR_SIZE 17

#define FONT_WIDTH 8
#define FONT_HEIGHT 8
#define FONT_CHAR_COUNT 95 // From space ' ' to '~'

const unsigned char image_data[IMAGE_SIZE] = {
    32, 8, 171, 16, 166, 19, 160, 22, 157, 27, 153, 15, 9, 7, 91, 8, 50, 15, 12, 6, 90, 10, 49, 13, 16, 5, 87, 12, 47, 12, 22, 4, 84, 15, 44, 12, 23, 5, 81, 36, 23, 12, 28, 2, 80, 40, 20, 11, 110, 11, 7, 24, 18, 11, 110, 10, 3, 5, 3, 21, 1, 4, 12, 12, 110, 9, 3, 4, 1, 4, 3, 24, 11, 13, 107, 11, 2, 5, 3, 5, 2, 19, 2, 3, 10, 12, 107, 12, 1, 6, 3, 6, 1, 19, 2, 3, 9, 12, 107, 12, 2, 5, 5, 5, 2, 23, 8, 11, 107, 14, 1, 6, 5, 6, 1, 23, 7, 12, 106, 14, 2, 5, 7, 5, 2, 22, 6, 12, 106, 15, 1, 6, 7, 6, 1, 22, 6, 12, 106, 15, 1, 6, 7, 6, 1, 22, 6, 11, 106, 16, 1, 6, 7, 6, 1, 21, 6, 11, 107, 16, 2, 5, 7, 5, 2, 20, 7, 11, 106, 18, 1, 6, 5, 6, 1, 18, 9, 10, 108, 18, 2, 5, 5, 5, 2, 16, 11, 10, 107, 20, 1, 6, 3, 6, 1, 15, 2, 2, 9, 10, 107, 20, 2, 5, 3, 5, 2, 13, 2, 4, 8, 11, 106, 22, 3, 4, 1, 4, 3, 10, 5, 4, 8, 11, 106, 25, 3, 5, 3, 10, 4, 6, 9, 11, 106, 27, 7, 9, 4, 8, 9, 12, 106, 43, 1, 10, 10, 12, 105, 42, 2, 10, 11, 12, 105, 19, 1, 21, 2, 10, 12, 12, 105, 18, 2, 18, 3, 10, 13, 14, 103, 18, 2, 16, 4, 10, 15, 14, 103, 18, 2, 14, 2, 14, 15, 14, 102, 19, 1, 15, 2, 12, 17, 14, 102, 19, 2, 10, 4, 12, 19, 14, 100, 21, 3, 25, 19, 14, 100, 23, 2, 21, 22, 14, 99, 45, 24, 14, 98, 45, 25, 15, 65, 20, 11, 45, 26, 16, 60, 30, 5, 44, 27, 16, 59, 31, 5, 41, 30, 16, 51, 82, 33, 17, 44, 88, 33, 18, 38, 2, 2, 88, 34, 18, 38, 90, 37, 18, 33, 93, 38, 18, 31, 94, 39, 20, 26, 96, 40, 21, 25, 96, 41, 21, 21, 98, 42, 22, 19, 99, 42, 25, 11, 102, 46, 136, 46, 136, 46, 135, 48, 134, 48, 134, 49, 133, 50, 131, 53, 129, 53, 129, 54, 127, 56, 95, 1, 30, 58, 24, 7, 60, 3, 28, 60, 28, 7, 87, 2, 1, 59, 27, 1, 4, 2, 52, 2, 32, 1, 3, 59, 33, 2, 49, 2, 33, 1, 4, 59, 34, 1, 47, 3, 31, 1, 4, 63, 33, 2, 44, 2, 32, 2, 5, 63, 32, 4, 41, 2, 18, 1, 14, 2, 6, 63, 33, 2, 40, 1, 19, 1, 14, 1, 8, 64, 7, 1, 26, 1, 38, 2, 19, 1, 13, 1, 9, 66, 5, 1, 26, 1, 37, 3, 17, 3, 11, 3, 9, 67, 3, 3, 25, 2, 35, 2, 19, 2, 10, 3, 12, 73, 24, 3, 34, 2, 17, 4, 10, 3, 13, 72, 26, 1, 34, 1, 18, 2, 8, 7, 13, 73, 25, 1, 33, 1, 18, 1, 10, 8, 12, 15, 4, 55, 24, 1, 33, 1, 17, 1, 9, 11, 11, 14, 5, 57, 22, 1, 32, 2, 15, 2, 9, 12, 12, 12, 6, 57, 22, 1, 47, 3, 8, 15, 11, 11, 7, 59, 6, 2, 12, 1, 47, 2, 5, 19, 11, 11, 5, 63, 3, 3, 12, 1, 31, 1, 14, 2, 4, 22, 14, 5, 5, 10, 3, 53, 2, 1, 14, 1, 30, 2, 14, 2, 4, 22, 23, 9, 7, 53, 15, 2, 29, 2, 13, 31, 21, 7, 9, 53, 15, 3, 28, 2, 13, 32, 21, 2, 13, 52, 16, 5, 26, 2, 13, 34, 33, 52, 15, 16, 14, 5, 13, 35, 22, 62, 15, 17, 13, 5, 13, 36, 20, 62, 15, 36, 13, 39, 16, 62, 15, 39, 12, 38, 11, 2, 5, 59, 16, 39, 13, 37, 12, 2, 5, 57, 15, 41, 13, 37, 13, 2, 4, 4, 5, 47, 16, 42, 12, 36, 6, 2, 6, 4, 11, 46, 14, 45, 12, 36, 5, 5, 4, 7, 9, 45, 14, 45, 13, 34, 7, 4, 4, 7, 9, 29, 1, 15, 13, 47, 12, 34, 7, 5, 4, 8, 7, 29, 3, 12, 12, 49, 12, 34, 7, 6, 4, 9, 5, 27, 6, 11, 11, 51, 11, 34, 7, 6, 6, 39, 9, 1, 6, 1, 10, 52, 11, 34, 7, 6, 6, 38, 27, 53, 12, 13, 1, 19, 6, 7, 7, 37, 26, 54, 13, 11, 3, 31, 7, 39, 9, 4, 17, 2, 9, 39, 11, 10, 6, 30, 6, 51, 29, 40, 11, 7, 8, 30, 6, 51, 30, 39, 11, 5, 10, 32, 4, 53, 12, 3, 13, 39, 11, 3, 10, 90, 3, 2, 3, 3, 2, 8, 7, 41, 20, 92, 4, 2, 3, 4, 3, 55, 16, 93, 6, 2, 3, 4, 4, 54, 15, 93, 6, 3, 3, 5, 4, 54, 14, 92, 6, 3, 4, 6, 3, 54, 15, 9, 1, 2, 1, 74, 8, 5, 4, 7, 6, 50, 19, 2, 8, 72, 9, 5, 4, 7, 7, 47, 15, 2, 15, 70, 7, 8, 4, 7, 8, 45, 11, 2, 4, 6, 10, 70, 7, 8, 4, 7, 9, 44, 6, 1, 4, 2, 5, 5, 10, 70, 8, 7, 5, 6, 9, 39, 11, 1, 4, 3, 6, 6, 6, 72, 7, 7, 5, 8, 7, 39, 10, 2, 4, 4, 6, 84, 6, 7, 7, 6, 6, 38, 8, 5, 5, 5, 6, 96, 7, 50, 8, 5, 1, 1, 3, 6, 6, 95, 7, 50, 8, 7, 3, 6, 8, 93, 7, 52, 6, 7, 3, 7, 8, 93, 6, 55, 2, 8, 4, 7, 8, 93, 3, 67, 4, 7, 9, 161, 6, 7, 8, 160, 8, 6, 7, 162, 7, 7, 6, 162, 7, 9, 3, 163, 6, 177, 4, 71
};
// Simple 8x8 font data. Each byte represents a row of 8 pixels.
const unsigned char font_data[FONT_CHAR_COUNT][FONT_HEIGHT] = {
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
};

unsigned char *const video_memory = (unsigned char *)0xA0000;

void outb(unsigned int port, unsigned char value) {
	__asm__ __volatile__ ("outb %%al,%%dx"::"d" (port), "a" (value));
}

void init_screen() {
    /* Configure palette with 8-bit RRRGGGBB color */
    outb(PALETTE_MASK, 0xFF);
    outb(PALETTE_WRITE, 0);

    for (unsigned char i = 0 ; i < 255 ; i++) {
        outb(PALETTE_DATA, (((i >> 5) & 0x07) * (256 / 8)) / 4);
        outb(PALETTE_DATA, (((i >> 2) & 0x07) * (256 / 8)) / 4);
        outb(PALETTE_DATA, (((i >> 0) & 0x03) * (256 / 4)) / 4);
    }

    /* Set color 255 = white */
    outb(PALETTE_DATA, 0x3F);
    outb(PALETTE_DATA, 0x3F);
    outb(PALETTE_DATA, 0x3F);
}

void draw_pixel(unsigned short x, unsigned short y, unsigned char color) {
    video_memory[x + (y * SCREEN_WIDTH)] = color;
}


void draw_logo(void) {
    unsigned int color = VC_BLACK;
    unsigned int pixel_index = 0; // A continuous counter for the current pixel
    unsigned int x, y;

    // Calculate the horizontal offset to center the logo
    unsigned int x_offset = (SCREEN_WIDTH - LOGO_RESOLUTION_W) / 2;

    for (int i = 0 ; i < IMAGE_SIZE ; i++) {
        // The value at image_data[i] is the number of pixels to draw
        unsigned int run_length = image_data[i];

        // Draw the current run of pixels
        for (unsigned int j = 0 ; j < run_length ; j++) {
            // Calculate x and y coordinates relative to the logo's resolution
            x = x_offset + (pixel_index % LOGO_RESOLUTION_W);
            y = pixel_index / LOGO_RESOLUTION_W;

            // Check to prevent drawing outside the logo's boundaries
            if (y < LOGO_RESOLUTION_H) {
                draw_pixel(x, y, color);
            }

            pixel_index++; // Increment the pixel counter
        }

        // After the run is finished, switch the color for the next run
        color = color == VC_BLACK ? VC_WHITE : VC_BLACK;
    }

        unsigned int text_y = LOGO_RESOLUTION_H + 20;

    // Draw the centered text
    draw_string(0, text_y, VC_WHITE, "GeckOs Bootloader");
}

void draw_char(unsigned short x, unsigned short y, unsigned char color, char c) {
    unsigned int char_index = -1;

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
        // default:
            // MISSING CHAR NEED TO FIX
    }

    const unsigned char *char_data = font_data[char_index];

    // Iterate through each row of the character
    for (int row = 0; row < FONT_HEIGHT; row++) {
        unsigned char row_data = char_data[row];
        // Iterate through each bit (pixel) in the row
        for (int col = 0; col < FONT_WIDTH; col++) {
            // Check if the bit is set (i.e., the pixel should be drawn)
            if ((row_data >> (7 - col)) & 1) {
                draw_pixel(x + col, y + row, color);
            }
        }
    }
}

void draw_string(unsigned short x, unsigned short y, unsigned char color, const char* str) {
    unsigned int string_width = LOGO_STR_SIZE * FONT_WIDTH;
    unsigned short current_x = x;

    // Calculate the horizontal offset to center the string
    unsigned int x_offset = (SCREEN_WIDTH - string_width) / 2;

    // Adjust the starting x coordinate
    current_x = x_offset;

    for (unsigned int i = 0; i < LOGO_STR_SIZE; i++) {
        draw_char(current_x, y, color, str[i]);
        current_x += FONT_WIDTH; // Move to the next character position
    }

}
