[bits 64]

[global boot64]
[extern GBL]

; TODO
DATA_SEG equ 0x10

%include "boot64_constants.S"

section  .text


boot64:
    cli
    mov rsp, 0x90000
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; xor rax, rax
    ; xor rbx, rbx
    ; xor rcx, rcx
    ; xor rdx, rdx

    ; Set up segment registers
    jmp GBL

    unreachable
