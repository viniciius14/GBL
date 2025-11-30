#ifndef __CONSOLE_H
#define __CONSOLE_H

#include "types.h"
#include "vga.h"

/* ---------------- Defines ---------------- */



/* ----------------- Types ----------------- */

#define ASCII_CHAR_COUNT    (15) // TODO replace me -> (95)

#define FONT_WIDTH          (8)
#define FONT_HEIGHT         (8)

#define DEFAULT_COLOUR      (VGA_WHITE)

/* ---------- Function prototypes ---------- */

void print_char(uint16_t x, uint16_t y, VgaColours colour, char c);
void print_hex(uint32_t n);
void print_string(uint16_t x, uint16_t y, VgaColours colour, const char* str, uint8_t strSize);

#endif /* __CONSOLE_H */
