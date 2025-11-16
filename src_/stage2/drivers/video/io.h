#ifndef __IO_H
#define __IO_H

/* ---------------- Defines ---------------- */

/* ----------------- Types ----------------- */

/* ---------- Function prototypes ---------- */

/* Outputs a byte to the specified hardware port */
void OutByte(unsigned short port, unsigned char data);

/* Outputs a word to the specified hardware port */
void OutWord(unsigned short port, unsigned short data);

/* Gets a byte from the specified hardware port */
unsigned char InByte(unsigned short port);

/* Gets a word from to the specified hardware port */
unsigned short InWord(unsigned short port);

/* Wait 1 I/O cycle */
void IoWait(void);

#endif /* __IO_H */