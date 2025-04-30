%ifndef __BIOS_UTILS_S
%define __BIOS_UTILS_S

%include "BIOS_print.S"

; Use the extended INT13h utilities for HDDs
%ifdef FAT12
    %include "BIOS_read.S"
%else
    %include "BIOS_read_ext.S"
%endif

%include "BIOS_disk_reset.S"
%include "BIOS_relocate.S"

%endif
