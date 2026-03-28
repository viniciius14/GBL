/* --------------- Includes ---------------- */

#include "FAT.h"

/* ---------- Function Prototypes ---------- */

static void FAT_findFile(const char *);
/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

static void FAT_findFile(const char * fileName) {
    // Call floppy disk driver to search read the FAT
    uint8_t fatBuffer[(FAT_REGION_START - RESERVED_REGION_START) * BYTES_PER_SECTOR] = {0};
    bool readOk = FloppyDiskController_read (
        FAT_REGION_START, // @TODO: Confirm this does not to be converted
        fatBuffer,
        FAT_REGION_START - RESERVED_REGION_START
    );
    // search the FAT for our fileName
}
