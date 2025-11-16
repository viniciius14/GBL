/* --------------- Includes ---------------- */

#include "io.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void OutByte(unsigned short port, unsigned char data){
    __asm__("outb %0, %1" : : "a"(data), "Nd"(port));
    return;
}


unsigned char InByte(unsigned short port){
    unsigned char res;
    __asm__("inb %1, %0" : "=a"(res) : "Nd"(port));
    return res;
}


void OutWord(unsigned short port, unsigned short data)
{
    __asm__("outw %w0, %1" : : "a" (data), "id" (port) );
}


unsigned short InWord(unsigned short port){
   unsigned short ret;
   __asm__("inw %1, %0" : "=a" (ret) : "dN" (port));
   return ret;
}


void IoWait(void) {
    __asm__("outb %%al, $0x80" : : "a"(0));
}