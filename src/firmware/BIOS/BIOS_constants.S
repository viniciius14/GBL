%ifndef __BIOS_CONSTANTS_S
%define __BIOS_CONSTANTS_S

; Memory map related constants
MEM_MAP_SMAP            equ 0x534D4150
MEM_MAP_ENTRY_COUNT     equ 32
MEM_MAP_ENTRY_SIZE      equ 24
MEM_MAP_MAX_SIZE        equ (MEM_MAP_ENTRY_SIZE * MEM_MAP_ENTRY_COUNT)

%endif
