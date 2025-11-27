#ifndef __IO_H
#define __IO_H

#include "types.h"
#include "utils.h"

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Outputs a byte to the specified hardware port */
void outByte(uint16_t port, uint8_t data);

/* Outputs a word to the specified hardware port */
void outWord(uint16_t port, uint16_t data);

/* Gets a byte from the specified hardware port */
uint8_t inByte(uint16_t port);

/* Gets a word from to the specified hardware port */
uint16_t inWord(uint16_t port);

/* Wait 1 I/O cycle */
void ioWait(void);

#endif /* __IO_H */