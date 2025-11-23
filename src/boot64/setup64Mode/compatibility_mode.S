%ifndef __COMPATIBILITY_MODE_S
%define __COMPATIBILITY_MODE_S

[bits 32]

[global compatibility_mode]

%include "boot64_constants.S"

section .text

compatibility_mode:
; ENABLE LONG MODE (EFER.LME)
    mov ecx, EFER_MSR
    rdmsr
    or eax, EFER_LM_ENABLE
    wrmsr

; ENABLE PAGING
    mov eax, cr0
    or eax, CR0_PG_ENABLE | CR0_PM_ENABLE   ; ensuring that PM is set will allow for jumping
                                            ; from real mode to compatibility mode directly
    mov cr0, eax
    ret

%endif