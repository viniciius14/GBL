%ifndef __BIOS_SET_VIDEO_MODE_S
%define __BIOS_SET_VIDEO_MODE_S

[bits 16]

section .text

[global BIOS_set_video_mode]

; Sets the video mode
; Inputs:
;   - al = Video mode
; Outputs:
;   - None
;
BIOS_set_video_mode:
    xor ah, ah
    int 0x10

    ret

%endif

; From https://stanislavs.org/helppc/int_10-0.html
; Possible video modes:
; 0x00  - 40x25   - B/W text               - (CGA, EGA, MCGA, VGA)
; 0x01  - 40x25   - 16 color text          - (CGA, EGA, MCGA, VGA)
; 0x02  - 80x25   - 16 shades of gray text - (CGA, EGA, MCGA, VGA)
; 0x03  - 80x25   - 16 color text          - (CGA, EGA, MCGA, VGA)
; 0x04  - 320x200 - 4 color graphics       - (CGA, EGA, MCGA, VGA)
; 0x05  - 320x200 - 4 color graphics       - (CGA, EGA, MCGA, VGA)
; 0x06  - 640x200 - B/W graphics           - (CGA, EGA, MCGA, VGA)
; 0x07  - 80x25   - Monochrome text        - (MDA, HERC, EGA, VGA)
; 0x08  - 160x200 - 16 color graphics      - (PCjr)
; 0x09  - 320x200 - 16 color graphics      - (PCjr)
; 0x0A  - 640x200 - 4 color graphics       - (PCjr)
; 0x0D  - 320x200 - 16 color graphics      - (EGA, VGA)
; 0x0E  - 640x200 - 16 color graphics      - (EGA, VGA)
; 0x0F  - 640x350 - Monochrome graphics    - (EGA, VGA)
; 0x10  - 640x350 - 16 color graphics      - (EGA or VGA with 128K)
; 0x11  - 640x480 - B/W graphics           - (MCGA, VGA)
; 0x12  - 640x480 - 16 color graphics      - (VGA)
; 0x13  - 320x200 - 256 color graphics     - (MCGA, VGA)

; CGA  -> Color graphics adapter
; EGA  -> Enhanced Graphics Adapter
; MCGA -> Multi-Color Graphics Array (IBM PS/2 systems)
; VGA  -> Video Graphics Array
; MDA  -> Monochrome Display Adapter
; HERC -> Hercules graphics (monochrome)
; PCjr -> IBM PC Junior graphics
