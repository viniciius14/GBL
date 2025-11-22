#include "vga.h"
#include "logo.h"

void GBL() {
    vga_init();

    draw_logo();

    while(1){}
}