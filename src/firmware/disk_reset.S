%ifndef __DISK_RESET_S
%define __DISK_RESET_S

%ifdef BIOS

%include "BIOS/BIOS_disk_reset.S"

%elifdef UEFI
%endif


%endif
