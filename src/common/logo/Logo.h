#ifndef __LOGO_H
#define __LOGO_H

/* --------------- Includes ---------------- */

#include "VideoGraphicsArray.h"
#include "Console.h"

/* ---------------- Defines ---------------- */

#define LOGO_STR_SIZE            (17)
#define GECKOS_LOGO_WIDTH        (182)
#define GECKOS_LOGO_HEIGHT       (132)
#define GECKOS_LOGO_CMPR_SIZE    (1015)

#define GECKOS_BOOT_MSG          "GeckOs Bootloader"

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

void GBL_logo(void);

#endif /* __LOGO_H */
