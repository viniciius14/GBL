### Technical debt
- Assuming 50 sector section will be enough/won't cause issues (stage2 fat implementations for FAT16 nd FAT32)
- Failure label jumping to BIOS_print instead of calling it (to call it we'd need to level the stack, so: mov sp, 0x7c00 and then we should be able to call stuff?)
- In the makefile for stage2 the loop to call the sub makefiles uses ";" making it so the compilation continues even in case of an error, && cannot be used as that leaves a trailing && (make && make &&)


### Features to add:
- Load one sector at a time for the FAT and the Root Directory
    - Add a "carousel" loader
- Define an area where the kernel can read the status information we've obtained while in real mode
    - Memory area
    - Video modes
- Check that the kernel is smaller than the total RAM area we have/the RAM is atleast N megabytes in size
    - Decide stack sizes and overall minimum RAM requirements. (for any given kernel ?)
- Add the cpu 8086 tag at the start of the code
- Add support for calculation dataRegionSector for all FATs
- What else to do in case of critical failure?
    - Just hang
    - Display an error code?
    - Reset?
- Replace the FAT header with a %define offset version
    - keep the current fat headers around for testing consistency purposes, add another makefile flag?

### Code standards:
- Align comments between all fats
- Align the style for the .S file
- Find the original reason we were using .S files and not .asm/.s files (old GeckOs project)

### Compilation:
- Review compiler flags
    - Try to get more performance or smaller code or both out of the GBL

### In accordance with the OS DEV wiki, Objectives:
 - [ ] Setup 16-bit segment registers and stack
 - [X] Print startup message
 - [ ] Check presence of PCI, CPUID, MSRs
 - [X] Enable and confirm enabled A20 line
 - [ ] Load GDTR
 - [ ] Inform BIOS of target processor mode
 - [X] Get memory map from BIOS
 - [ ] Locate kernel in filesystem
 - [ ] Allocate memory to load kernel image
 - [ ] Load kernel image into buffer
 - [X] Enable graphics mode
 - [ ] Check kernel image ELF headers
 - [ ] Enable long mode, if 64-bit
 - [ ] Allocate and map memory for kernel segments
 - [ ] Setup stack
 - [ ] Setup COM serial output port
 - [ ] Setup IDT
 - [ ] Disable PIC
 - [ ] Check presence of CPU features (NX, SMEP, x87, PCID, global pages, TCE, WP, MMX, SSE, SYSCALL), and enable them
 - [ ] Assign a PAT to write combining
 - [ ] Setup FS/GS base
 - [ ] Load IDTR
 - [ ] Enable APIC and setup using information in ACPI tables
 - [ ] Setup GDT and TSS

### Objectives 2:
 - [ ] Setup "the" GBL welcome message in video mode
 - [ ] Add UEFI support
 - [ ] Add support for more filesystems
 - [ ] Add BOCHS emulation support
 - [ ] Finally get docker working

### Future Objectives (big maybes):
 - [ ] Add support for other architectures
 - [ ] Add a submodule with a custom BIOS


### TODO:
 - [ ] Edit scripts/qemu_gdb to work with both GDB versions dynamically
    - [ ] Check docker for this program (and personal pc aswell)
 - [ ] Refactor to 64 bit code as it's complete spaghetti rn
