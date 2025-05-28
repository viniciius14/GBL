%ifndef __BIOS_READ_EXT_S
%define __BIOS_READ_EXT_S

[bits 16]

section .text

[global BIOS_read]

%ifndef STAGE_1
[extern failure]
%endif

; Use BIOS INT13h Extensions to read sectors from disk into RAM
; Inputs:
;   - AX = LBA address
;   - CL = number of sectors to read (up to 127)
;   - DL = drive number
;   - ES:BX = memory address where to store read data
; Outputs:
;   - None
;
BIOS_read:
    push si
    mov [DAPACK.sectorLow],     ax
    mov [DAPACK.sectorCount],   cx
    mov [DAPACK.bufferOffset],  bx
    mov [DAPACK.bufferSegment], es

    mov si, DAPACK          ; Address of "disk address packet"
    mov ah, 0x42
    int 0x13

    jc failure

    pop si
    ret

; Disk Address Packet Structure
DAPACK:
.size:          db  0x10    ; Packet size (16 bytes)
.reserved:      db  0x00    ; Reserved, should always be 0
.sectorCount:   dw  0x00    ; Number of sectors to read
.bufferOffset:  dw  0x00    ; Offset to load sectors
.bufferSegment: dw  0x00    ; Segment to load sectors
.sectorLow:     dd  0x00    ; Lower 32 bits of LBA sector
.sectorHigh:    dd  0x00    ; Upper 32 bits of LBA sector

%endif
