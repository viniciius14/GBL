%ifndef __LONG_MODE_S
%define __LONG_MODE_S

[bits 64]

[global long_mode]

[extern GDT]
[extern __kernel_entry]

%include "common.S"

section .text

long_mode:
    cli

    ; mov ax, GDT.Data
    xor ax, ax ; Todo fix this
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp __kernel_entry

    unreachable

%endif