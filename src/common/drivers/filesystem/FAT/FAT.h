#ifndef __FAT_H
#define __FAT_H

/* --------------- Includes ---------------- */

#include "FloppyDiskController.h"

/* ---------------- Defines ---------------- */

#define RESERVED_REGION_START           (0)

#if defined (FAT12)
    #define FAT_REGION_START            (1)    // 1 reserved sector
    #define ROOT_DIRECTORY_REGION_START (19)   // 2 FAT each occupying 9 sectors
    #define DATA_REGION_START           (33)   // 0xE0 entries at 32 bytes each = 7168 bytes => 14 sectors
#elif defined (FAT16)
    #define FAT_REGION_START            (4)    // 4 reserved sectors
    #define ROOT_DIRECTORY_REGION_START (272)  // 2 FAT each occupying 134 sectors
    #define DATA_REGION_START           (304)  // 0x200 entries at 32 bytes each = 16384 => 32 sectors
#elif defined (FAT32)
    #define FAT_REGION_START            (32)   // 32 reserved sector
    #define ROOT_DIRECTORY_REGION_START (-1)   // Not applicable for FAT32
    #define DATA_REGION_START           (1096) // 2 FAT each occupying 532 sectors
#endif

#define BYTES_PER_SECTOR                (512)

/* ----------------- Types ----------------- */



/* ---------- Function prototypes ---------- */



#endif /* __FAT_H */
