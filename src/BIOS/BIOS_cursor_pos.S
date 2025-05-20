%ifndef __BIOS_CURSOR_POS_S
%define __BIOS_CURSOR_POS_S

; Inputs:
;   - DH = row
;   - DL = column
; Outputs:
;   - Sets the cursor at the specified position
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
