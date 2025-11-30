#ifndef __LOGO_H
#define __LOGO_H

/* --------------- Includes ---------------- */

#include "vga.h"
#include "console.h"

/* ---------------- Defines ---------------- */

#define LOGO_STR_SIZE       (17)
#define LOGO_RESOLUTION_W   (182)
#define LOGO_RESOLUTION_H   (132)
#define GECKO_LOGO_SIZE     (1015)

/* ----------------- Types ----------------- */



/* ---------- Function prototypes ---------- */

void GBL_logo(void);

#endif /* __LOGO_H */
