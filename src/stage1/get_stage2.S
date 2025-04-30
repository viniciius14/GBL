; Find and load the stage 2 file in the current filesystem
; Inputs:
;   SI = pointer to 11-byte filename of stage 2
; Outputs:
;   Loads file into 0x7E00 if found, else jumps to failure
get_stage2:
%ifdef FAT_FS
    call FAT_find_file

    sub ax, 2                   ; clusters are numbered starting from 2, not from 0
    mov [currentCluster], ax
    xor bx, bx
    mov es, bx
    mov bx, STAGE2_OFFSET
    call FAT_load_chain

%endif

    ret

%ifdef FAT12
    %include "FAT12_utils.S"
%elifdef FAT16
    %include "FAT16_utils.S"
%elifdef FAT32
    %include "FAT32_utils.S"
%endif
