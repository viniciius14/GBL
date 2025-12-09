#ifndef __TYPES_H
#define __TYPES_H

/* ---------------- Defines ---------------- */

#define NULL                    ((void*) 0)

#define MAX_UINT08              (0xFF)
#define MAX_UINT16              (0xFFFF)
#define MAX_UINT32              (0xFFFFFFFF)
#define MAX_UINT64              (0xFFFFFFFFFFFFFFFF)

#define MAX_INT08               (0x7F)
#define MAX_INT16               (0x7FFF)
#define MAX_INT32               (0x7FFFFFFF)
#define MAX_INT64               (0x7FFFFFFFFFFFFFFF)

#define MIN_INT08               (0x80)
#define MIN_INT16               (0x8000)
#define MIN_INT32               (0x80000000)
#define MIN_INT64               (0x8000000000000000)

#define MAX_FLOAT32             (3.402823466e+38f)
#define MAX_FLOAT64             (1.7976931348623158e+308f)

#define MIN_FLOAT32             (1.175494351e-38f)
#define MIN_FLOAT64             (2.2250738585072014e-308f)

#define TRUE                    (1)
#define FALSE                   (0)

/* ----------------- Types ----------------- */

typedef unsigned char           uint8_t;
typedef unsigned short          uint16_t;
typedef unsigned int            uint32_t;
typedef unsigned long long      uint64_t;

typedef char                    int8_t;
typedef short int               int16_t;
typedef int                     int32_t;
typedef long long               int64_t;

typedef float                   float32_t;
typedef double                  float64_t;

typedef uint8_t                 bool;

/* ---------- Function prototypes ---------- */

/* None */

#endif /* __TYPES_H */
