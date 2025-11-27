/* --------------- Includes ---------------- */

#include "io.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void outByte(uint16_t port, uint8_t data) {
    ASM("outb %0, %1" : : "a"(data), "Nd"(port));
    return;
}

uint8_t inByte(uint16_t port) {
    uint8_t res;
    ASM("inb %1, %0" : "=a"(res) : "Nd"(port));
    return res;
}

void outWord(uint16_t port, uint16_t data) {
    ASM("outw %w0, %1" : : "a" (data), "id" (port) );
}

uint16_t inWord(uint16_t port){
   uint16_t ret;
   ASM("inw %1, %0" : "=a" (ret) : "dN" (port));
   return ret;
}

void ioWait(void) {
    ASM("outb %%al, $0x80" : : "a"(0));
}
