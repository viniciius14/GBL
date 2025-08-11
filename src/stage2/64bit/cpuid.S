%ifndef __CPUID_S
%define __CPUID_S

[bits 32]

%include "common.S"

[global checkCPUID]

; Inputs:
;   - NONE
; Outputs:
;   - eax = 1 on success
;   - eax = 0 on failure
;
checkCPUID:
    pushfd
    pop eax

    mov ecx, eax            ; Save the original value for later
    xor eax, EFLAGS_ID

    ; storing the eflags and then retrieving it again will show whether or not
    ; the bit could successfully be flipped
    push eax                    ; save to eflags
    popfd
    pushfd                      ; restore from eflags
    pop eax

    ; Restore EFLAGS to its original value
    push ecx
    popfd

    ; if the bit in eax was successfully flipped (eax != ecx), CPUID is supported.
    xor eax, ecx
    jnz .supported

.notSupported:
    mov ax, 0
    ret

.supported:
    mov ax, 1
    ret

%endif
