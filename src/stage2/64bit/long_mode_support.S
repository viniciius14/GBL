%ifndef __LONG_MODE_SUPPORT_S
%define __LONG_MODE_SUPPORT_S

CPUID_EXTENSIONS   equ 0x80000000 ; returns the maximum extended requests for cpuid
CPUID_EXT_FEATURES equ 0x80000001 ; returns flags containing long mode support among other things


.queryLongMode:
    mov eax, CPUID_EXTENSIONS
    cpuid
    cmp eax, CPUID_FEATURES
    jb .NoLongMode              ; if the CPU can't report long mode support, then it likely
                                ; doesn't have it

CPUID_EDX_EXT_FEAT_LM equ 1 << 29   ; if this is set, the CPU supports long mode

    mov eax, CPUID_EXT_FEATURES
    cpuid
    test edx, CPUID_EDX_EXT_FEAT_LM
    jz .NoLongMode

%endif
