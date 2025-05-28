[bits 16]

[global stage2_16bit]
[global failure]
[global GBL_InfoStruct]

[extern A20_line]
[extern stage2_32bit]

%include "common.S"
%include "BIOS_utils.S"

section .text

section stage2_16bit.text

stage2_16bit:
    cli

    xor ax, ax                  ; null segments
    mov ds, ax
    mov es, ax

    mov si, MSG_stage2_16
    call BIOS_print

    mov dx, 0x0100              ; set cursor to line 1
    call BIOS_cursor_pos

; Enable A20 line
    call A20_line

    mov dx, 0x0200              ; set cursor to line 2
    call BIOS_cursor_pos

; Fill in the memory map section of the GBL InfoStruct
    mov di, GBL_InfoStruct.memMapEntries
    mov ecx, [GBL_InfoStruct.memMapSize]
    call BIOS_detect_mem

    jmp $

    pusha                       ; save registers
    lgdt [GDT_Descriptor]       ; load GDT
    popa                        ; restore registers

 ; set bit 0 in cr0
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    ; in al, 0x92                 ; Enable A20 gate
    ; or al, 0x02
    ; out 0x92, al

    CODE_SEG equ code_descriptor - GDT_Start
    DATA_SEG equ data_descriptor - GDT_Start

    jmp CODE_SEG:stage2_32bit

failure:
    mov si, MSG_ERROR
    jmp BIOS_print
    unreachable


; TODO section .bss
section .data
; TODO: Later on relocate this into a well know address
; GeckOS Bootloader Information Structure®
BEFORE:             dd "DEAD"
GBL_InfoStruct:
.structureSize:     dw GBL_InfoStruct - GBL_InfoStruct.end
.memMapSize:        dw MMAP_ENTRIES_SIZE
.memMapEntries:     times (MMAP_ENTRIES_SIZE) db 0
.videoMode:         dw 0x0
.end:
AFTER:              dd "DEAD"

; TODO section .data
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

; TODO: Can this be section .rodata ?

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1  ; size
    dd GDT_Start                ; start


section .rodata

MSG_stage2_16:      db "Got to stage 2 of the bootloader. (16 bits)", 0
MSG_ERROR:          db "CRITICAL ERROR", 0

%include "FAT_header.S"
