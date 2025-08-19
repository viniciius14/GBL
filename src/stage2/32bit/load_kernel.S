[bits 32]

[global _load_kernel]

[extern print_string_32]

%include "common.S"
%include "S2_constants.S"

section .text

; Find and load the kernel
; Inputs:
;   - NONE
; Outputs:
;   - eax = 1 on success
;   - eax = 0 on failure
;
_load_kernel:
; load root dir to fat buffer
; find our file
; load kernel to intermediary location
; relocate it over the 1MB boundary
; print success message

    ret

section .rodata
checkpointKernel: db "Successfully loaded the kernel.", 0
