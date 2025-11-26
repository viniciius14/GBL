%ifndef __BIOS_CURSOR_POS_S
%define __BIOS_CURSOR_POS_S

[bits 16]

section .text

; Sets the cursor at the specified position
; Inputs:
;   - DH = row
;   - DL = column
; Outputs:
;   - None
;
BIOS_cursor_pos:
    push ax
    push bx

    mov ah, 2
    mov bh, 0
    int 0x10

    pop bx
    pop ax

    ret


%endif
