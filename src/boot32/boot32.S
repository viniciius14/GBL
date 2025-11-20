[bits 32]

[global boot32]

[extern vga_init]
[extern draw_logo]
[extern load_kernel]

%ifdef BITS64
[extern stage2_64bit]
%endif

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

    call vga_init
    call draw_logo

    ; call load_kernel

%ifdef BITS64
    call stage2_64bit        ; switch to long mode
%endif

    ; jmp __KERNEL_ENTRY_ADDR

    unreachable

section .rodata

stage2msg2: db "Got to stage 2 of the bootloader. (32 bits)", 0
