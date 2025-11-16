[bits 16]

; [global setup]
; [global failure]
; ; [global GBL_InfoStruct]

; [extern A20_line]
; ; [extern set_GDT]
; [extern failure]

section .text

%include "GDT/A20.S"
%include "GDT/GDT.S"

setup32Bit:
    ; cli

    xor ax, ax                  ; null segments
    mov ds, ax
    mov es, ax

    ; mov si, MSG_stage2_16
    ; call BIOS_print

    ; mov dx, 0x0100              ; set cursor to line 1
    ; call BIOS_cursor_pos

; Enable A20 line
    call A20_line

    ; mov dx, 0x0200              ; set cursor to line 2
    ; call BIOS_cursor_pos

; Fill in the memory map section of the GBL InfoStruct
    ; mov di, GBL_InfoStruct.memMapEntries
    ; mov ecx, [GBL_InfoStruct.memMapSize]
    ; call BIOS_detect_mem

; Switches to graphics mode 0x13
    mov al, 0x13
    ; call BIOS_set_video_mode
    ; Todo Replace this with an actuall call to the firmware dirs set_video_mode
    xor ah, ah
    int 0x10

; Set the Global Descriptor Table
    call set_GDT

 ; Set bit 0 in cr0
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    ret



; TODO section .bss
; section .data
; ; TODO: Later on relocate this into a well know address
; ; GeckOS Bootloader Information Structure®
; BEFORE:             dd "DEAD"
; GBL_InfoStruct:
; .structureSize:     dw GBL_InfoStruct - GBL_InfoStruct.end
; .memMapSize:        dw MEM_MAP_MAX_SIZE
; .memMapEntries:     times (MEM_MAP_MAX_SIZE) db 0
; .videoMode:         dw 0x0
; .end:
; AFTER:              dd "DEAD"


; section .rodata

; MSG_stage2_16:      db "Got to stage 2 of the bootloader. (16 bits)", 0
; MSG_ERROR:          db "CRITICAL ERROR", 0
; MSG_welcome:        db "Welcome to GBL, the GeckOS Bootloader!", 0

; %include "FAT_header.S"
