[bits 32]

[global boot32]

[extern GBL]
[extern setup64Mode]

%include "boot32_constants.S"

section boot32.text

boot32:
 ; Set up segment registers
    mov ax, 16
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

%ifdef BITS64
    jmp setup64Mode        ; switch to long mode
%else
    jmp GBL
%endif

    unreachable

section .rodata

stage2msg2: db "Got to stage 2 of the bootloader. (32 bits)", 0
