[bits 64]

[global stage2_64bit]

[extern checkCPUID]
[extern extendedFunctionsSupport]
[extern compatibility_mode]
[extern setup_paging]
[extern submode64]

section stage2_64bit.text

%include "common.S"
%include "S2_constants.S"

%ifdef BITS64

stage2_64bit:
    call checkCPUID
    cmp eax, 1
    jne fatal_error

    call extendedFunctionsSupport
    cmp eax, 1
    jne fatal_error

    call compatibility_mode

    call setup_paging

    jmp submode64

fatal_error:
; Do stuff
    unreachable

%endif
