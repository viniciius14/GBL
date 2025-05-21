%ifndef __BIOS_DETECT_MEM_S
%define __BIOS_DETECT_MEM_S

[bits 16]

section .text

[global BIOS_detect_mem]

[extern BIOS_print]
[extern failure]

; Writes to the given pointer the memory map of the installed RAM by consecutively calling int 0x15
; Inputs:
;   - ECX = Buffer size (will fill in at most ECX bytes)
;   - ES:DI = Buffer pointer
; Outputs:
;   - None
;
BIOS_detect_mem:
    push ecx                ; store the buffer size
    xor ebx, ebx
    jmp .call               ; since this is the first call skipp the loop setup

.loop_setup:
; update available buffer size
    mov edx, ecx        ; number of bytes written to the buffer
    pop ecx
    sub ecx, edx        ; subtract from buffer size the number of bytes written in the last call
    push ecx
; update buffer pointer
    add edi, edx

.call:
    mov eax, 0xE820
    mov edx, BIOS_MMAP_SMAP
    ; ebx will be set from the previous or be 0
    int 0x15

; if carry flag is set it means there was an error
    jc .end

; or if eax is different from "SMAP"
    cmp eax, BIOS_MMAP_SMAP
    jne .end

; else continue looping
    jmp .loop_setup

.end:
    pop ecx

    mov si, MSG_BIOS_MemMap
    call BIOS_print

    ret

section .rodata
MSG_BIOS_MemMap:    db "Memory map read from int 0x15.", 0

%endif