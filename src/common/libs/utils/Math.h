#ifndef __MATH_H
#define __MATH_H

/* ---------------- Defines ---------------- */

#define MIN(_x, _y)             (_x < _y ? _x : _y)
#define MAX(_x, _y)             (_x > _y ? _x : _y)
#define CLAMP(_x, _min, _max)   (MAX(_min, MIN(_max, _x)))

#define ABS(_x)                 ((_x) < 0 ? -(_x) : (_x))
#define SIGN(_x)                ((_x) < 0 ? -1 : ((_x) > 0 ? 1 : 0))

#define FLOOR(_x)               ((int)(_x))
#define CEIL(_x)                ((int)(_x) + 1)

#define PI                      (3.14159265358979323846f)
#define TAU                     (2.0 * PI)
#define E                       (2.71828182845904523536f)
#define radians(_x)             ((_x) * (__typeof__(_x)) (PI / 180.0f))
#define degrees(_x)             ((_x) * (__typeof__(_x)) (180.0f / PI))

/* ----------------- Types ----------------- */

/* None */

/* ---------- Function prototypes ---------- */

/* None */

#endif /* __MATH_H */
