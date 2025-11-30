#ifndef __VGA_H
#define __VGA_H

#include "io.h"

/* ---------------- Defines ---------------- */

/* VGA control port addresses */
typedef enum {
    VGA_PALETTE_MASK    = 0x3C6,
    VGA_PALETTE_READ    = 0x3C7,
    VGA_PALETTE_WRITE   = 0x3C8,
    VGA_PALETTE_DATA    = 0x3C9,
} VgaRegAddress;

/* VGA colours */
typedef enum {
    VGA_BLACK        = 0x00,
    VGA_RED          = 0xE0,
    VGA_GREEN        = 0x1C,
    VGA_YELLOW       = 0xFC,
    VGA_PINK         = 0xE3,
    VGA_CYAN         = 0x1F,
    VGA_L_GREY       = 0x6D,
    VGA_WHITE        = 0xFF,
} VgaColours;

#define VGA_SCREEN_WIDTH    (320)
#define VGA_SCREEN_HEIGHT   (200)

#define SCREEN_SIZE         (VGA_SCREEN_WIDTH * VGA_SCREEN_HEIGHT)

/* ----------------- Types ----------------- */



/* ---------- Function prototypes ---------- */

void vga_init();
void vga_draw_pixel(uint16_t x, uint16_t y, VgaColours colour);

#endif /* __VGA_H */
