[bits 32]

[global setup64Mode]

[extern checkCPUID]
[extern extendedFunctionsSupport]
[extern compatibility_mode]
[extern setup_paging]
[extern submode64]

%include "boot64_constants.S"

section .text

setup64Mode:
    call checkCPUID
    cmp eax, 1
    jne fatal_error

    call extendedFunctionsSupport
    cmp eax, 1
    jne fatal_error

    call compatibility_mode

    call setup_paging

    jmp submode64

fatal_error:
; Do stuff
    unreachable

submode64:
    lgdt [GDT.Pointer]
    jmp GDT.Code:boot64

%include "boot64.S"


section .rodata

GDT:
.Null: equ $ - GDT
    dq 0
.Code: equ $ - GDT
    .Code.limit_lo: dw 0xffff
    .Code.base_lo:  dw 0
    .Code.base_mid: db 0
    .Code.access:   db PRESENT | NOT_SYS | EXEC | RW
    .Code.flags:    db GRAN_4K | LONG_MODE | 0xF   ; Flags & Limit (high, bits 16-19)
    .Code.base_hi:  db 0
.Data: equ $ - GDT
    .Data.limit_lo: dw 0xffff
    .Data.base_lo:  dw 0
    .Data.base_mid: db 0
    .Data.access:   db PRESENT | NOT_SYS | RW
    .Data.Flags:    db GRAN_4K | SZ_32 | 0xF       ; Flags & Limit (high, bits 16-19)
    .Data.base_hi:  db 0
.Pointer:
    dw $ - GDT - 1
    dq GDT
