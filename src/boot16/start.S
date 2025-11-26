[bits 16]
[org 0x7C00]

section .text

; TODO temporary solution
%define BIOS

%include "defines.S"
%include "boot16_constants.S"
%include "header.S"

start:
    cli
    cld
    jmp 0x0000:.stage1_start

.stage1_start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, STACK_START     ; Set the stack pointer
    mov [BS_DrvNum], dx     ; Overwrite the drive number with the one the BIOS gives us

; Clear the screen by switching to text mode
    mov ah, 0x0
    mov al, 0x3
    int 0x10

    mov si, stage2FileName

; Find stage 2 of the bootloader and then load it into memory
    call find_file

    xor bx, bx
    mov es, bx
    mov bx, STAGE2_OFFSET
    call load_file

    jmp 0x0:STAGE2_OFFSET

%include "drivers.S"

failure:
    hlt
    jmp $

stage2FileName:         db "GBL_S2  BIN"
errorMsg:               db "CRITICAL ERROR", 0
currentCluster:         dw 0
dataRegionSector:       dw FAT_DATA_START

times (510 - ($ - $$)) db 0
dw 0xAA55

%include "footer.S"
