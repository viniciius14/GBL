/* --------------- Includes ---------------- */

#include "VideoGraphicsArray.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

static uint8_t *const VideoGraphicsArray_memory = (uint8_t *)0xA0000;

/* -------- Function Implementations ------- */

void VideoGraphicsArray_init (void) {
    /* Configure palette with 8-bit RRRGGGBB colour */
    Io_outByte(VGA_PALETTE_MASK, 0xFF);
    Io_outByte(VGA_PALETTE_WRITE, 0);

    for (uint8_t i = 0 ; i < 255 ; i++) {
        Io_outByte(VGA_PALETTE_DATA, (((i >> 5) & 0x07) * (256 / 8)) / 4);
        Io_outByte(VGA_PALETTE_DATA, (((i >> 2) & 0x07) * (256 / 8)) / 4);
        Io_outByte(VGA_PALETTE_DATA, (((i >> 0) & 0x03) * (256 / 4)) / 4);
    }

    /* Set colour 255 = white */
    Io_outByte(VGA_PALETTE_DATA, 0x3F);
    Io_outByte(VGA_PALETTE_DATA, 0x3F);
    Io_outByte(VGA_PALETTE_DATA, 0x3F);
}

INLINE void VideoGraphicsArray_drawPixel (uint16_t x, uint16_t y, VideoGraphicsArray_colour colour) {
    VideoGraphicsArray_memory[x + (y * VGA_SCREEN_WIDTH)] = colour;
}

INLINE void VideoGraphicsArray_clearScreen (VideoGraphicsArray_colour colour) {
    Memory_set(VideoGraphicsArray_memory, (uint8_t) colour, SCREEN_SIZE);
}

INLINE void VideoGraphicsArray_drawHorizontalLine(const uint16_t x, const uint16_t y, const uint16_t size, const VideoGraphicsArray_colour colour) {
    Memory_set(&VideoGraphicsArray_memory[x + (y * VGA_SCREEN_WIDTH)], (uint8_t) colour, size);
}
