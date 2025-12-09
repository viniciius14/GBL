#ifndef __VIDEOGRAPHICSARRAY_H
#define __VIDEOGRAPHICSARRAY_H

#include "Io.h"
#include "Memory.h"

/* ---------------- Defines ---------------- */

/* VGA control port addresses */
typedef enum {
    VGA_PALETTE_MASK    = 0x3C6,
    VGA_PALETTE_READ    = 0x3C7,
    VGA_PALETTE_WRITE   = 0x3C8,
    VGA_PALETTE_DATA    = 0x3C9,
} VideoGraphicsArray_regAddres;

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
} VideoGraphicsArray_colour;

#define VGA_SCREEN_WIDTH    (320)
#define VGA_SCREEN_HEIGHT   (200)

#define SCREEN_SIZE         (VGA_SCREEN_WIDTH * VGA_SCREEN_HEIGHT)

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void VideoGraphicsArray_init();
void VideoGraphicsArray_drawPixel(uint16_t x, uint16_t y, VideoGraphicsArray_colour colour);
void VideoGraphicsArray_clearScreen(VideoGraphicsArray_colour colour);
void VideoGraphicsArray_drawHorizontalLine(const uint16_t x, const uint16_t y, const uint16_t size, const VideoGraphicsArray_colour colour);

#endif /* __VIDEOGRAPHICSARRAY_H */
