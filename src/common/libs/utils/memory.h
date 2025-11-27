#ifndef __MEMORY_H
#define __MEMORY_H

#include "types.h"
#include "utils.h"

/* ---------------- Defines ---------------- */



/* ----------------- Types ----------------- */



/* ---------- Function prototypes ---------- */

/* Sets n bytes of memory to value starting at address dst */
void memSet(void *const dst, const uint8_t value, uint32_t n);

/* Copies n bytes of memory from src to dst */
void *memCpy(void *const dst, const void *src, uint32_t n);

/* Moves n bytes from src to dst */
void convertLbaChs(const uint32_t lba,  uint8_t * const cyl, uint8_t * const head, uint8_t * const sector);

#endif /* __MEMORY_H */
