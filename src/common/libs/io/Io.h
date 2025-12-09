#ifndef __IO_H
#define __IO_H

#include "Types.h"
#include "Utils.h"

/* ---------------- Defines ---------------- */

/* None */

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

/* Outputs a byte to the specified hardware port */
void Io_outByte (uint16_t port, uint8_t data);

/* Outputs a word to the specified hardware port */
void Io_outWord (uint16_t port, uint16_t data);

/* Gets a byte from the specified hardware port */
uint8_t Io_inByte (uint16_t port);

/* Gets a word from to the specified hardware port */
uint16_t Io_inWord (uint16_t port);

/* Wait 1 I/O cycle */
void Io_wait (void);

#endif /* __IO_H */