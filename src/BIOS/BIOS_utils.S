%ifndef __BIOS_UTILS_S
%define __BIOS_UTILS_S

; This file includes all the BIOS utilities into a single %include call for simplicity

%include "BIOS_print.S"

; Use the extended INT13h utilities for non FAT12 systems (HDDs, DVDs, etc)
%ifdef FAT12
    %include "BIOS_read.S"
%else
    %include "BIOS_read_ext.S"
%endif

%include "BIOS_disk_reset.S"
%include "BIOS_relocate.S"
%include "BIOS_cursor_pos.S"
%include "BIOS_detect_mem.S"
%include "BIOS_set_video_mode.S"

%endif
