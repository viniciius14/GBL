%ifndef __EXTENDED_FUNCTIONS_S
%define __EXTENDED_FUNCTIONS_S

[bits 32]

[global extendedFunctionsSupport]

%include "S2_constants.S"

section .text

; Check if the current CPU supports extended fucntions
; Inputs:
;   - NONE
; Outputs:
;   - eax = 1 on success
;   - eax = 0 on failure
;
extendedFunctionsSupport:
    mov eax, CPUID_EXTENSIONS
    cpuid
    cmp eax, CPUID_EXT_FEATURES
    jb .noExtendedFunctions

    mov eax, 1

.noExtendedFunctions:
    mov eax, 0
    ret

%endif
