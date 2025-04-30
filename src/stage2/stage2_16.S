[bits 16]

[global _stage2_16]

[extern _stage2_32]

%include "common.S"

section _stage2_16.text

_stage2_16:
    cli

    xor ax, ax                  ; null segments
    mov ds, ax
    mov es, ax

    mov si, stage2msg1
    call BIOS_print

    pusha                       ; save registers
    lgdt [GDT_Descriptor]       ; load GDT
    popa                        ; restore registers

    mov eax, cr0                ; set bit 0 in cr0
    or  eax, 1
    mov cr0, eax

    in al, 0x92                 ; Enable A20 gate
    or al, 0x02
    out 0x92, al

    CODE_SEG equ code_descriptor - GDT_Start
    DATA_SEG equ data_descriptor - GDT_Start

    jmp CODE_SEG:_stage2_32

failure:
    mov si, error_msg
    jmp BIOS_print
    unreachable

section .text

%include "BIOS_utils.S"
; %include "FAT_utils.S"

section .data

currentCluster:         dw 0
data_start_lba:         dw 0
dataRegionSector:       dw FAT_DATA_START

section .rodata

stage2msg1:         db "Got to stage 2 of the bootloader. (16 bits)", 0
file_kernel:        db "KERNEL_NAME", 0
error_msg:          db "CRITICAL ERROR", 0

GDT_Start:
    null_descriptor:
        dd  0
        dd  0
    code_descriptor:
        dw 0xFFFF
        dw 0                    ; 16 bits +
        db 0                    ; 8 bits = 24
        db 0b10011010           ; type flags
        db 0b11001111           ; other flags
        db 0                    ; last 8 bits of base
    data_descriptor:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10010010
        db 0b11001111
        db 0
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1  ; size
    dd GDT_Start                ; start

%include "FAT_header.S"
