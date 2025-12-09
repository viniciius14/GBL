/* --------------- Includes ---------------- */

#include "Io.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

void Io_outByte (uint16_t port, uint8_t data) {
    ASM("outb %0, %1" : : "a"(data), "Nd"(port));
    return;
}

uint8_t Io_inByte (uint16_t port) {
    uint8_t res;
    ASM("inb %1, %0" : "=a"(res) : "Nd"(port));
    return res;
}

void Io_outWord (uint16_t port, uint16_t data) {
    ASM("outw %w0, %1" : : "a" (data), "id" (port) );
}

uint16_t Io_inWord (uint16_t port){
   uint16_t ret;
   ASM("inw %1, %0" : "=a" (ret) : "dN" (port));
   return ret;
}

void Io_wait (void) {
    ASM("outb %%al, $0x80" : : "a"(0));
}
