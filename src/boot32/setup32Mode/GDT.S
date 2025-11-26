%ifndef __GDT_S
%define __GDT_S

%define CODE_SEG GDT32.code - GDT32
%define DATA_SEG GDT32.data - GDT32

[bits 16]

section .text

set_GDT:
    cli                     ; disable interrupts
    lgdt [GDT_Descriptor]   ; load GDT

    ret

section .data

GDT32:
    .null:
        dd  0
        dd  0
    .code:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10011010
        db 0b11001111
        db 0
    .data:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10010010
        db 0b11001111
        db 0
GDT32_End:

; TODO: Can this be: section .rodata ?
section .rodata
GDT_Descriptor:
    dw GDT32_End - GDT32 - 1  ; size
    dd GDT32                ; start

%endif
