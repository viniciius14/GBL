#include "vga.h"
#include "logo.h"

void GBL() {
    vga_init();

    draw_logo();

    unsigned int text_y = LOGO_RESOLUTION_H + 20;

    // Draw the centered text
    draw_string(0, text_y, VC_WHITE, "GeckOs Bootloader");

    while(1){;}
}
