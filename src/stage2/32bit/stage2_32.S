[bits 32]

[global stage2_32bit]

[extern _load_kernel]
; [extern print_string_32]

%ifdef BITS64
[extern stage2_64bit]
%endif

%include "macros.S"

section stage2_32bit.text

stage2_32bit:
 ; Set up segment registers
    mov ax, 16
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov edi, 0xA0000
    mov eax, 0x01010101         ; 4 pixels with color index 1 (blue-ish)
    mov ecx, 320*200/4
    rep stosd

    unreachable

%ifdef BITS64
;     call stage2_64bit        ; switch to long mode
%endif

    jmp _load_kernel

    unreachable

section .rodata

stage2msg2: db "Got to stage 2 of the bootloader. (32 bits)", 0
