#ifndef __MEMORY_H
#define __MEMORY_H

#include "Types.h"
#include "Utils.h"

/* ---------------- Defines ---------------- */

/* None */

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

/* Sets n bytes of memory to value starting at address dst */
void Memory_set(uint8_t *const dst, const uint8_t value, uint32_t n);

/* Copies n bytes of memory from src to dst */
void *Memory_copy(uint8_t *const dst, const uint8_t *src, uint32_t n);

void *Memory_move (uint8_t *const dst, uint8_t *const src, const uint32_t n);

/* Moves n bytes from src to dst */
void Memory_lbaToChs(const uint32_t lba,  uint8_t * const cyl, uint8_t * const head, uint8_t * const sector);

#endif /* __MEMORY_H */
