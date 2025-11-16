%ifndef __DEFINES_S
%define __DEFINES_S

; Checks for conflicting defines
%ifdef BITS32
    %ifdef BITS64
        %error "Conflicting flag BITS defined."
    %endif
%endif

%assign FS_COUNT 0

%ifdef FAT12
    %assign FS_COUNT FS_COUNT + 1
%endif
%ifdef FAT16
    %assign FS_COUNT FS_COUNT + 1
%endif
%ifdef FAT32
    %assign FS_COUNT FS_COUNT + 1
%endif

%if FS_COUNT = 0
    %error "No filesystem type defined."
%elif FS_COUNT > 1
    %error "Conflicting filesystem types defined. Define only 1."
%endif

%ifndef KERNEL_NAME
    %error "KERNEL_NAME is not defined."
%endif

%assign KERNEL_NAME_SIZE 0

%strlen KERNEL_NAME_SIZE KERNEL_NAME

%if KERNEL_NAME_SIZE != 11
    %error "KERNEL_NAME must be exactly 11 characters long (8.3 format)."
%endif

; Composite defines
%ifdef FAT12
    %define FAT_FS
%elifdef FAT16
    %define FAT_FS
%elifdef FAT32
    %define FAT_FS
%endif

%endif
