[bits 32]

[global _stage2_32]

[extern _load_kernel]
[extern print_string_32]

%ifdef BITS64
[extern _stage2_64]
%endif

%include "macros.S"

section _stage2_32.text

_stage2_32:

    mov	ax, 0x10            ; set data segments to data selector (0x10)
	mov	ds, ax
	mov	ss, ax
	mov	es, ax

    mov esi, stage2msg2
    mov ebx, 160

    call print_string_32


%ifdef BITS64
;     call _stage2_64        ; switch to long mode
%endif

    jmp _load_kernel

    unreachable

section .data

stage2msg2: db "Got to stage 2 of the bootloader. (32 bits)", 0
