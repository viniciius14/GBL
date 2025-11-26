%ifndef __LONG_MODE_SUPPORT_S
%define __LONG_MODE_SUPPORT_S

[bits 32]

[global isLongModeSupported]

%include "boot64_constants.S"

section .text

; Check if the current CPU supports long mode
; Inputs:
;   - NONE
; Outputs:
;   - eax = 1 if long mode supported
;   - eax = 0 if long mode not supported
;
isLongModeSupported:
    mov eax, CPUID_EXT_FEATURES
    cpuid
    test edx, CPUID_EDX_EXT_FEAT_LM
    setnz al                    ; Set al = 1 if zero flag is NOT set (bit was set)
    movzx eax, al               ; Zero-extend to eax
    ret

%endif
