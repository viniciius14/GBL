[bits 32]

[global stage2_32bit]

[extern _load_kernel]
[extern print_string_32]

%ifdef BITS64
[extern stage2_64bit]
%endif

%include "macros.S"

section stage2_32bit.text

stage2_32bit:

    mov	ax, 0x10            ; set data segments to data selector (0x10)
	mov	ds, ax
	mov	ss, ax
	mov	es, ax

    mov esi, stage2msg2
    mov ebx, 160

    call print_string_32


%ifdef BITS64
;     call stage2_64bit        ; switch to long mode
%endif

    jmp _load_kernel

    unreachable

section .rodata

stage2msg2: db "Got to stage 2 of the bootloader. (32 bits)", 0
