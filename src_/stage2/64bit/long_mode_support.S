%ifndef __LONG_MODE_SUPPORT_S
%define __LONG_MODE_SUPPORT_S

[bits 32]

[global isLongModeSupported]

%include "S2_constants.S"

section .text

; Check if the current CPU supports long mode
; Inputs:
;   - NONE
; Outputs:
;   - eax = 1 on success
;   - eax = 0 on failure
;
isLongModeSupported:
    mov eax, CPUID_EXT_FEATURES
    cpuid
    test edx, CPUID_EDX_EXT_FEAT_LM     ; if this is set, the CPU supports long mode
    jz .noLongMode
    mov eax, 1

.noLongMode:
    mov eax, 0
    ret

%endif
