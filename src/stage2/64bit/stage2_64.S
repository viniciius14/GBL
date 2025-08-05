[bits 64]

[global stage2_64bit]

[extern _load_kernel]

section .text

%ifdef BITS64

stage2_64bit:

    ; check for 64 bit support
    ; change to 64 bit mode
    jmp $

%endif
