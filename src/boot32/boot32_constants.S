%ifndef __BOOT32_DEFINITIONS_S
%define __BOOT32_DEFINITIONS_S

%macro unreachable 0
    cli             ; disable interrupts
    hlt             ; halt the CPU
    jmp $
%endmacro

%endif
