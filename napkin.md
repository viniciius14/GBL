Technical debt:
    - For some reason having ASM_FLAGS in the config.mk makes it so our flags don't get added to it, moved the var to GBL/Makefile
    - Assuming 50 sector section will be enough/won't cause issues
    - In the makefile we have to pass in the PROJECT dir as a hardcoded value because makefile will reevaluate it otherwise
    - In the makefile (stage1) we have to pass in the FS, BITS and KERNEL_NAME defines individually and can't add them to the ASM_FLAGS variable in the main Makefile for some reason

Features to add:
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

Code standards:
    - Align comments between all fats
    - Align the style for the .S file
    - Find the original reason we were using .S files and not .asm/.s files

Compilation:
    - Review compiler flags
        - Try to get more performance or smaller code or both out of the GBL
