%ifndef __FAT_INCLUDE_S
%define __FAT_INCLUDE_S

%include "FAT_header.S"
%include "S1_constants.S"

%ifdef FAT12
    %include "FAT12_utils.S"
%elifdef FAT16
    %include "FAT16_utils.S"
%elifdef FAT32
    %include "FAT32_utils.S"
%endif

%endif