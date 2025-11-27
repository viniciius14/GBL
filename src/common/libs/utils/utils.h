#ifndef __UTILS_H
#define __UTILS_H

/* ---------------- Defines ---------------- */

#define PACKED                  __attribute__((packed))
#define INTERRUPT               __attribute__((interrupt))
#define NORETURN                __attribute__((noreturn))
#define WEAK                    __attribute__((weak))
#define INLINE                  __attribute__((always_inline)) inline
#define NO_INLINE               __attribute__((noinline))
#define NO_DISCARD              __attribute__((warn_unused_result))
#define ALIGNED(_alignment)     __attribute__((aligned(_alignment)))
#define SECTION(_section)       __attribute__((section(_section)))

#define STRINGIFY(x)            #x
#define TOSTRING(x)             STRINGIFY(x)

#define STATIC_ASSERT(_cond)    _Static_assert(_cond, #_cond " failed at line " TOSTRING(__LINE__) " of file " __FILE__)

#define UNREACHABLE()           __builtin_unreachable()

#define STI()                   __asm__ __volatile__("sti")
#define CLI()                   __asm__ __volatile__("cli")
#define ASM                     __asm__ __volatile__

#define BIT(_n)                 (1ULL <<  (_n))
#define BIT_SET(_x, _mask)      ((_x) |=  (_mask))
#define BIT_CLEAR(_x, _mask)    ((_x) &= ~(_mask))
#define BIT_FLIP(_x, _mask)     ((_x) ^=  (_mask))
#define BIT_TEST(_x, _mask)     ((_x) &   (_mask))


/* ----------------- Types ----------------- */



/* ---------- Function prototypes ---------- */



#endif /* __UTILS_H */
