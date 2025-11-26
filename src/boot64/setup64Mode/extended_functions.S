%ifndef __EXTENDED_FUNCTIONS_S
%define __EXTENDED_FUNCTIONS_S

[bits 32]

[global extendedFunctionsSupport]

%include "boot64_constants.S"

section .text

; Check if the current CPU supports extended functions
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
    setb al              ; Set al = 1 if below (no extended functions), 0 otherwise
    movzx eax, al        ; Zero-extend al into eax
    xor eax, 1           ; Flip the bit (1 becomes 0, 0 becomes 1)
    ret

%endif
