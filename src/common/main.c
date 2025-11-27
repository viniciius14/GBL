#include "vga.h"
#include "logo.h"

NORETURN void GBL() {
    vga_init();

    draw_logo();

    while(1){;}

    UNREACHABLE();
}
