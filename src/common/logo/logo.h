#ifndef __LOGO_H
#define __LOGO_H

/* --------------- Includes ---------------- */

#include "vga.h"

/* ---------------- Defines ---------------- */

#define LOGO_STR_SIZE       17

#define FONT_WIDTH          8
#define FONT_HEIGHT         8
#define FONT_CHAR_COUNT     15

#define LOGO_RESOLUTION_W   182
#define LOGO_RESOLUTION_H   132

#define IMAGE_SIZE          1015

/* ----------------- Types ----------------- */



/* ---------- Function prototypes ---------- */

void draw_logo(void);
void draw_char(unsigned short x, unsigned short y, unsigned char color, char c);
void draw_string(unsigned short x, unsigned short y, unsigned char color, const char* str);

#endif /* __LOGO_H */
