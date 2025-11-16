%ifndef __SET_VIDEO_MODE_S
%define __SET_VIDEO_MODE_S

%ifdef BIOS

%include "BIOS/BIOS_set_video_mode.S"

%elifdef UEFI
%endif

%endif
