%ifndef __DRIVERS_S
%define __DRIVERS_S

; Define the API that will decide what code to call

; Find a file in the current filesystem
; Inputs:
;   DS:SI = pointer to filename
;   DL = Drive Number
; Outputs:
;   AX = starting cluster in the data section
%ifdef FAT12
; File Requirements
    %include "read.S"
    %include "disk_reset.S"

    %include "drivers/FAT/FAT12_utils.S"
%elifdef FAT16
    %include "drivers/FAT/FAT16_utils.S"
%elifdef FAT32
    %include "drivers/FAT/FAT32_utils.S"
%endif

; Inputs:
;   AX = starting cluster number
;   ES:BX = memory address to load file to
; Outputs:
;
;
%ifdef FAT12
    %include "drivers/FAT/FAT12_utils.S"
%elifdef FAT16
    %include "drivers/FAT/FAT16_utils.S"
%elifdef FAT32
    %include "drivers/FAT/FAT32_utils.S"
%endif

%endif
