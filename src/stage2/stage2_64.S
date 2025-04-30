[bits 64]   ; assuming it'll be succesfull...?
[global _stage2_64]
[extern _load_kernel]

section .text

%ifdef BITS64

_stage2_64:

    ; check for 64 bit support
    ; change to 64 bit mode
    jmp $

%endif
