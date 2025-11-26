[bits 32]

[global setup64Mode]
[global GDT64.Data]
[global GDT64]

[extern checkCPUID]
[extern extendedFunctionsSupport]
[extern compatibility_mode]
[extern setup_paging]
[extern submode64]
[extern boot64]

%include "boot64_constants.S"
%define CODE_SEG GDT64.Code - GDT64
%define DATA_SEG GDT64.Data - GDT64

section setup64Mode.text

setup64Mode:
    mov esp, 0x9000
    call checkCPUID
    cmp eax, EFLAGS_ID
    jne fatal_error

    call extendedFunctionsSupport
    cmp eax, 1
    jne fatal_error

    call setup_paging

    call compatibility_mode

    ; Verify Paging is actually on (using TEST, not CMP)
    test eax, CR0_PG_ENABLE
    jz fatal_error

    jmp submode64

fatal_error:
; Turns the screen red to indicate a failed check
    mov edi, 0xA0000
    mov ecx, 16000
    mov eax, 0x28282828
    cld
    rep stosd
    unreachable

submode64:
    lgdt [GDT64.Pointer]
    ; Load the new 64-bit compatible data segment into DS, ES, SS, FS, GS
    ; Final jump into 64-bit mode. This jump reloads CS and switches the CPU mode.
    jmp CODE_SEG:boot64

section .data
align 16
GDT64:
    .Null:
        dq 0
    .Code:
        .Code.limit_lo: dw 0xffff
        .Code.base_lo: dw 0
        .Code.base_mid: db 0
        .Code.access: db PRESENT | NOT_SYS | EXEC | RW
        .Code.flags: db GRAN_4K | LONG_MODE | 0xF   ; Flags & Limit (high, bits 16-19)
        .Code.base_hi: db 0
    .Data:
        .Data.limit_lo: dw 0xffff
        .Data.base_lo: dw 0
        .Data.base_mid: db 0
        .Data.access: db PRESENT | NOT_SYS | RW
        .Data.Flags: db GRAN_4K | SZ_32 | 0xF       ; Flags & Limit (high, bits 16-19)
        .Data.base_hi: db 0
    .Pointer:
        dw $ - GDT64 - 1
        dq GDT64
