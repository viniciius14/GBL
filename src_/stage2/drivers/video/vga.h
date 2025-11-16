#ifndef __VGA_H
#define __VGA_H

#include "io.h"

/* ---------------- Defines ---------------- */

/* VGA control port addresses */
#define PALETTE_MASK    0x3C6
#define PALETTE_READ    0x3C7
#define PALETTE_WRITE   0x3C8
#define PALETTE_DATA    0x3C9

/* VGA colors */
#define VC_BLACK        0x00
#define VC_RED          0xE0
#define VC_GREEN        0x1C
#define VC_YELLOW       0xFC
#define VC_PINK         0xE3
#define VC_CYAN         0x1F
#define VC_L_GREY       0x6D
#define VC_WHITE        0xFF

#define SCREEN_WIDTH    320
#define SCREEN_HEIGHT   200

#define SCREEN_SIZE     (SCREEN_WIDTH * SCREEN_HEIGHT)

/* ----------------- Types ----------------- */



/* ---------- Function prototypes ---------- */

void vga_init();
void vga_draw_pixel(unsigned short x, unsigned short y, unsigned char color);

#endif /* __VGA_H */
