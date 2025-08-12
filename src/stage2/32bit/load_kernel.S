%ifdef BITS64
[bits 64]
%else
[bits 32]
%endif

[global _load_kernel]

; [extern print_string_32]
; load the kernel into address 0x________
%include "macros.S"
%include "constants.S"

section .text

_load_kernel:
    mov esi, stage2msg3     ; Point ESI to the string
    mov ebx, 320            ; Start at the top-left corner of the screen
    ; to delete later
    ; call print_string_32

; load root dir to fat buffer
; find our file
;

    mov esp, kernel_stack + KERNEL_STACK_SIZE

    jmp $

    unreachable

section .rodata
stage2msg3: db "Got to load kernel. (32 bits)", 0

section .bss
align 16
kernel_stack:
    resb KERNEL_STACK_SIZE
