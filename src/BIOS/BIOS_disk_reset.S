%ifndef __BIOS_DISK_RESET_S
%define __BIOS_DISK_RESET_S

[bits 16]

section .text

[global BIOS_disk_reset]

; Resets disk controller
; Inputs:
;   - DL = drive number
; Outputs:
;   - None
;
BIOS_disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc failure          ; if an error occurs during a reset, give up

    popa
    ret

%endif
