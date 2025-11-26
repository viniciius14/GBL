#ifndef __IO_H
#define __IO_H

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Outputs a byte to the specified hardware port */
void outByte(unsigned short port, unsigned char data);

/* Outputs a word to the specified hardware port */
void outWord(unsigned short port, unsigned short data);

/* Gets a byte from the specified hardware port */
unsigned char inByte(unsigned short port);

/* Gets a word from to the specified hardware port */
unsigned short inWord(unsigned short port);

/* Wait 1 I/O cycle */
void ioWait(void);

#endif /* __IO_H */