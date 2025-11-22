%ifndef __LONG_MODE_S
%define __LONG_MODE_S

[bits 64]

[global long_mode]

[extern GDT]
[extern __KERNEL_ENTRY_ADDR]

%include "boot64_constants.S"

section .text

; Entry for 64 bit long mode
; Inputs:
;   - NONE
; Outputs:
;   - NONE
;
long_mode:
    cli
    unreachable
    ; mov ax, GDT.Data
    xor ax, ax ; Todo fix this
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp __KERNEL_ENTRY_ADDR

    unreachable

%endif