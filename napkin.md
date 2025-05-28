### Technical debt
- For some reason having ASM_FLAGS in the config.mk makes it so our flags don't get added to it, moved the var to GBL/Makefile
- Assuming 50 sector section will be enough/won't cause issues
- In the makefile we have to pass in the PROJECT dir as a hardcoded value because makefile will reevaluate it otherwise
- In the makefile (stage1) we have to pass in the FS, BITS and KERNEL_NAME defines individually and can't add them to the ASM_FLAGS variable in the main Makefile for some reason

### Features to add:
- Load one sector at a time for the FAT and the Root Directory
    - Add a "carousel" loader
- Define an area where the kernel can read the status information we've obtained while in real mode
    - Memory area
    - Video modes
- Check that the kernel is smaller than the total RAM area we have/the RAM is atleast N megabytes in size
- Add the cpu 8086 tag at the start of the code
- Add support for calculation dataRegionSector for all FATs
- What else to do in case of critical failure?
    - Just hang
    - Display an error code?
    - Reset?

### Code standards:
- Align comments between all fats
- Align the style for the .S file
- Find the original reason we were using .S files and not .asm/.s files

### Compilation:
- Review compiler flags
    - Try to get more performance or smaller code or both out of the GBL

### In accordance with the OS DEV wiki, Objectives:
 - [ ] Setup 16-bit segment registers and stack
 - [ ] Print startup message
 - [ ] Check presence of PCI, CPUID, MSRs
 - [X] Enable and confirm enabled A20 line
 - [ ] Load GDTR
 - [ ] Inform BIOS of target processor mode
 - [X] Get memory map from BIOS
 - [ ] Locate kernel in filesystem
 - [ ] Allocate memory to load kernel image
 - [ ] Load kernel image into buffer
 - [ ] Enable graphics mode
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
