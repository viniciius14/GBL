%ifndef __BIOS_DETECT_MEM_S
%define __BIOS_DETECT_MEM_S

[bits 16]

section .text

[global BIOS_detect_mem]

%ifndef STAGE_1
[extern BIOS_print]
%endif

; Writes to the given pointer the memory map of the installed RAM by consecutively calling int 0x15
; Inputs:
;   - ECX = Buffer size (will fill in at most ECX bytes)
;   - ES:DI = Buffer pointer
; Outputs:
;   - None
;
BIOS_detect_mem:
    push ecx                    ; store the total buffer size
    xor ebx, ebx                ; since it's the first call, set ebx to 0

.loop:
    mov eax, 0xE820
    mov ecx, MMAP_ENTRY_SIZE
    mov edx, MMAP_SMAP
    ; ebx will be set from the previous call or be 0

    int 0x15

; set the last 4 byte block to 1 (little endian) to make the map ACPI compatible
    mov byte [edi + 20], 1

; if carry flag is set, return
    jc .end

; if eax is different from "SMAP", return
    cmp eax, MMAP_SMAP
    jne .end

; if less than 20 bytes were written, return
    cmp ecx, 20
    jl .end

; if continuation value is 0, return
    cmp ebx, 0
    je .end

; update available buffer size
    mov eax, ecx                ; number of bytes written to the buffer
    pop ecx                     ; get the buffer size
    sub ecx, eax                ; buffer size -= number of bytes written
    cmp ecx, MMAP_ENTRY_SIZE    ; check if there's space for more entries
    jl .end

    push ecx                    ; store buffer size
    add edi, MMAP_ENTRY_SIZE    ; buffer pointer += (max) entry size

    jmp .loop

.end:
    pop ecx

    mov si, MSG_BIOS_MemMap
    call BIOS_print

    ret

section .rodata
MSG_BIOS_MemMap:    db "Memory map read from BIOS.", 0

%endif