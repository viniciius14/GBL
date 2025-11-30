/* --------------- Includes ---------------- */

#include "vga.h"
#include "logo.h"
#include "fdc.h"

/* ---------- Function Prototypes ---------- */

void GBL_init();

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

NORETURN void GBL() {
    GBL_logo();

    GBL_init();

    while(1){;}

    UNREACHABLE();
}

void GBL_init() {
    vga_init();
    fdc_init();
}
