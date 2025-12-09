#ifndef __CONSOLE_H
#define __CONSOLE_H

#include "Types.h"
#include "VideoGraphicsArray.h"

/* ---------------- Defines ---------------- */

#define ASCII_CHAR_COUNT    (128)

#define FONT_WIDTH          (8)
#define FONT_HEIGHT         (8)

#define DEFAULT_COLOUR      (VGA_WHITE)

/* ----------------- Types ----------------- */

typedef const enum {
    // Custom control character, replaces form feed
    // \a
    CONSOLE_SCREEN_CLEAR = 0x7,
    // \t
    CONSOLE_TAB = 0x9,
    // \n
    CONSOLE_LINE_FEED = 0xA,
    // \r
    CONSOLE_CARRIAGE_RETURN = 0xD,
} Console_specialCharacter;

/* ---------- Function prototypes ---------- */

void Console_init(void);
void Console_printHex(uint32_t n);
void Console_printString(VideoGraphicsArray_colour colour, const char * str);
void Console_printStringCentered(VideoGraphicsArray_colour colour, const char * str, uint16_t y);
void Console_printStringAtLocation (VideoGraphicsArray_colour colour, const char * str, uint16_t x, uint16_t y);
#endif /* __CONSOLE_H */
