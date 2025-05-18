[bits 16]
[org 0x7C00]

section .text

%define STAGE_1

%include "common.S"

%ifdef FAT_FS
    %include "FAT_header.S"
%endif

stage1:
    ; Clear the screen
    ; Switches to text mode
    mov ah, 0x0
    mov al, 0x3
    int 0x10

    ; Switches to graphics mode 0x13 -> Resolution: 320 x 200 | Adapter: EGA | Colors: 16 bit
    ; mov ah, 0x0
    ; mov al, 0x13
    ; int 0x10

    cli                     ; Clear interrupt flag
    cld                     ; Clear direction flag
    xor ax, ax              ; Clear main registers
    mov bx, ax
    mov cx, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, STAGE2_STACK
    mov [BS_DrvNum], dx     ; Overwrite the drive number with the one the BIOS gives us
    mov si, fileStage2Bin

    ; Find stage 2 of the bootloader and then load it into memory
    call load_stage2

    jmp STAGE2_SEGMENT:STAGE2_OFFSET

%include "BIOS_utils.S"
%include "load_stage2.S"

; Common label to jump to when a critical error is found
failure:
    mov si, errorMsg
    call BIOS_print
    unreachable

fileStage2Bin:          db "STAGE2  BIN"
errorMsg:               db "CRITICAL ERROR", 0
currentCluster:         dw 0
dataRegionSector:       dw FAT_DATA_START

times (510 - ($ - $$)) db 0
dw 0xAA55

%ifdef FAT32
    %include "FAT32_FSInfo.S"
%endif
