%ifndef __PRINT_S
%define __PRINT_S


%ifdef BIOS

%include "BIOS/BIOS_print.S"

%elifdef UEFI

%endif

%endif
