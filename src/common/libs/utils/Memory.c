/* --------------- Includes ---------------- */

#include "Memory.h"

/* ---------- Function Prototypes ---------- */

/* None */

/* ----------- Global Variables ------------ */

/* None */

/* -------- Function Implementations ------- */

INLINE void Memory_set (uint8_t *const dst, const uint8_t value, uint32_t n) {
    uint8_t *d = dst;
    while (n-- > 0) {
        *(d++) = value;
    }
}

void *Memory_copy (uint8_t *const dst, const uint8_t *src, uint32_t n) {
    uint8_t *d = dst;
    const uint8_t *s = src;

    while (n-- > 0) {
        *(d++) = *(s++);
    }
    return dst;
}

void *Memory_move (uint8_t *const dst, uint8_t *const src, const uint32_t n) {
    if (src > dst) {
        return Memory_copy(dst, src, n);
    }

    uint8_t *d = dst;
    const uint8_t *s = src;

    for (uint32_t i = n ; i > 0 ; i--) {
        d[i - 1] = s[i - 1];
    }

    return dst;
}

/* Convert LBA addressing into CHS addressing */
INLINE void Memory_lbaToChs (const uint32_t lba,  uint8_t * const cyl, uint8_t * const head, uint8_t * const sector) {
    *cyl    = lba / (2 * 18);
    *head   = ((lba % (2 * 18)) / 18);
    *sector = ((lba % (2 * 18)) % 18 + 1);
}
