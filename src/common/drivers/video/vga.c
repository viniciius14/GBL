/* --------------- Includes ---------------- */

#include "vga.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

unsigned char *const video_memory = (unsigned char *)0xA0000;

/* -------- Function Implementations ------- */

void vga_init() {
    /* Configure palette with 8-bit RRRGGGBB color */
    outByte(PALETTE_MASK, 0xFF);
    outByte(PALETTE_WRITE, 0);

    for (unsigned char i = 0 ; i < 255 ; i++) {
        outByte(PALETTE_DATA, (((i >> 5) & 0x07) * (256 / 8)) / 4);
        outByte(PALETTE_DATA, (((i >> 2) & 0x07) * (256 / 8)) / 4);
        outByte(PALETTE_DATA, (((i >> 0) & 0x03) * (256 / 4)) / 4);
    }

    /* Set color 255 = white */
    outByte(PALETTE_DATA, 0x3F);
    outByte(PALETTE_DATA, 0x3F);
    outByte(PALETTE_DATA, 0x3F);
}

void vga_draw_pixel(unsigned short x, unsigned short y, unsigned char color) {
    video_memory[x + (y * SCREEN_WIDTH)] = color;
}
