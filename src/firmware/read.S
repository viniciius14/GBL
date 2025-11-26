%ifndef __READ_S
%define __READ_S

%ifdef BIOS

%ifdef FAT12
    %include "BIOS/BIOS_read.S"
%else
    %include "BIOS/BIOS_read_ext.S"
%endif

%elifdef UEFI
%endif

%endif
