/* --------------- Includes ---------------- */

#include "VideoGraphicsArray.h"
#include "Logo.h"
#include "FloppyDiskController.h"

/* ---------- Function Prototypes ---------- */

void GBL_init();

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

NORETURN void GBL() {
    GBL_init();

    while(1){;}
    UNREACHABLE();
}

void GBL_init() {
    Console_init();
    VideoGraphicsArray_init();
    FloppyDiskController_init();

    GBL_logo();
}
