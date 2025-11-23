%ifndef __CPUID_S
%define __CPUID_S

[bits 32]

[global checkCPUID]

%include "boot64_constants.S"

section .text

; Check if the current CPU supports the CPUID instruction
; Inputs:
;   - NONE
; Outputs:
;   - eax = 1 on success
;   - eax = 0 on failure
;
checkCPUID:
    pushfd                      ; Save EFLAGS
    pushfd                      ; Store EFLAGS
    xor dword [esp], EFLAGS_ID  ; Invert the ID bit in stored EFLAGS
    popfd                       ; Load stored EFLAGS (with ID bit inverted)
    pushfd                      ; Store EFLAGS again (ID bit may or may not be inverted)
    pop eax                     ; eax = modified EFLAGS (ID bit may or may not be inverted)
    xor eax,[esp]               ; eax = whichever bits were changed
    popfd                       ; Restore original EFLAGS
    and eax, EFLAGS_ID          ; eax = zero if ID bit can't be changed, else non-zero
    ret

%endif
