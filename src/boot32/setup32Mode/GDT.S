%ifndef __GDT_S
%define __GDT_S

%define CODE_SEG GDT_Start.code_descriptor - GDT_Start
%define DATA_SEG GDT_Start.data_descriptor - GDT_Start

[bits 16]

section .text

set_GDT:
    cli                     ; disable interrupts
    lgdt [GDT_Descriptor]   ; load GDT

    ret

section .data

GDT_Start:
    .null_descriptor:
        dd  0
        dd  0
    .code_descriptor:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10011010
        db 0b11001111
        db 0
    .data_descriptor:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10010010
        db 0b11001111
        db 0
GDT_End:

; TODO: Can this be: section .rodata ?
GDT_Descriptor:
    dw GDT_End - GDT_Start - 1  ; size
    dd GDT_Start                ; start

%endif
