; Find and load the stage 2 file in the current filesystem
; Inputs:
;   SI = pointer to 11-byte filename of stage 2
; Outputs:
;   Loads file into 0x7E00 if found, else jumps to failure
load_stage2:
%ifdef FAT_FS
    call FAT_find_file

    xor bx, bx
    mov es, bx
    mov bx, STAGE2_OFFSET
    call FAT_load_chain
%endif

    ret

%include "BIOS_print.S"
%include "BIOS_disk_reset.S"

; Use the extended INT13h utilities for HDDs
%ifdef FAT12
    %include "BIOS_read.S"
%else
    %include "BIOS_read_ext.S"
%endif

%ifdef FAT12
    %include "FAT12_utils.S"
%elifdef FAT16
    %include "FAT16_utils.S"
%elifdef FAT32
    %include "FAT32_utils.S"
%endif
