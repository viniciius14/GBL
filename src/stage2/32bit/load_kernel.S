[bits 32]

[global load_kernel]

%include "common.S"
%include "S2_constants.S"
%include "FAT_include.S"

section .text

; Find and load the kernel
; Inputs:
;   - NONE
; Outputs:
;   - eax = 1 on success
;   - eax = 0 on failure
;
load_kernel:
; find our file
    mov si, fileKernel
    call FAT_find_file

; load kernel to intermediary location
    xor ebx, ebx
    mov es, ebx
    mov ebx, KERNEL_BUFFER_START
    call FAT_load_chain

; relocate it over the 1MB boundary
.relocate_kernel:
    ; Set up segment registers for source and destination.
    ; We will use DS:SI for the source and ES:DI for the destination.
    mov ax, KERNEL_BUFFER_START >> 4    ; Calculate source segment address
    mov ds, ax                          ; Set DS to the start of the buffer
    xor si, si                          ; Set source offset to 0

    mov eax, KERNEL_START >> 4           ; Calculate destination segment address
    mov es, eax                          ; Set ES to the final kernel location
    xor di, di                          ; Set destination offset to 0

    ; Set the count for the copy operation.
    ; We are copying the entire kernel buffer size.
    mov ecx, KERNEL_BUFFER_SIZE

    ; Set the direction flag to copy forward.
    cld    ; Clear Direction Flag (DF=0), causes SI and DI to increment

    ; Use the 'rep movsb' instruction to perform the copy.
    ; This instruction copies the byte at DS:SI to ES:DI,
    ; and then increments SI and DI. It repeats this CX times.
    rep movsb

    ; Relocation is complete. You can now jump to the new kernel entry point.
    ; This is a placeholder for your jump instruction.
    ; jmp KERNEL_START:0x0000
; print success message

    ret
failure:
    unreachable

section .rodata
currentCluster:         dw 0
; %ifdef FAT12
;     FAT_DATA_START      equ (0x1 + (0x2 * 0x9) + ((0xE0 * 32) + 0x200 - 1) / 0x200)
; %elifdef FAT16
;     FAT_DATA_START      equ (0x4 + (0x2 * 0x86) + ((0x200 * 32) + 0x200 - 1) / 0x200)
; %elifdef FAT32
;     FAT_DATA_START      equ (0x20 + (0x2 * 0x214))
; %endif
dataRegionSector:       dw FAT_DATA_START
section .rodata

fileKernel:         db "GECKOS  BIN"
