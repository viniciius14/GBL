/* --------------- Includes ---------------- */

#include "vga.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

uint8_t *const video_memory = (uint8_t *)0xA0000;

/* -------- Function Implementations ------- */

void vga_init() {
    /* Configure palette with 8-bit RRRGGGBB colour */
    outByte(VGA_PALETTE_MASK, 0xFF);
    outByte(VGA_PALETTE_WRITE, 0);

    for (uint8_t i = 0 ; i < 255 ; i++) {
        outByte(VGA_PALETTE_DATA, (((i >> 5) & 0x07) * (256 / 8)) / 4);
        outByte(VGA_PALETTE_DATA, (((i >> 2) & 0x07) * (256 / 8)) / 4);
        outByte(VGA_PALETTE_DATA, (((i >> 0) & 0x03) * (256 / 4)) / 4);
    }

    /* Set colour 255 = white */
    outByte(VGA_PALETTE_DATA, 0x3F);
    outByte(VGA_PALETTE_DATA, 0x3F);
    outByte(VGA_PALETTE_DATA, 0x3F);
}

void vga_draw_pixel(uint16_t x, uint16_t y, VgaColours colour) {
    video_memory[x + (y * VGA_SCREEN_WIDTH)] = colour;
}


