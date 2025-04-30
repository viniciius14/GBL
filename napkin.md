Technical debt:
    - For some reason having ASM_FLAGS in the config.mk makes it so our flags don't get added to it, moved the var to GBL/Makefile
    - Assuming 50 sector section will be enough/won't cause issues

Features to add:
    - Add in the makefile the debug target
    - Add in the makefile the option to pass in KERNEL_NAME for the all target
    - Load one sector at a time for the FAT and the Root Directory
        - keep track of the current sector and if the info we want is not loaded, read the next one
    - Define an area where the kernel can read the status information we've obtained while in real mode
        - Memory area
        - Video modes
    - Check that the kernel is smaller than the total RAM area we have/the RAM is atleast N megabytes in size
    - Extended read vs "normal" read
        - decide if we'll do it by defines or dynamically
    - Add the cpu 8086 tag at the start of the code
    - Add support for calculation dataRegionSector for all FATs
    - Add checks for the A20 line and it's support
        - What to do if it is not supported?
    - What else to do in case of critical failure?
        - Just hang
        - Display an error code?
        - Reset?

Code standards:
    - Align comments between all fats
    - Align the style for the .S file
    - Find the original reason we were using .S files and not .asm/.s files
