# GBL
GeckOS Bootloader

This project is meant to be the bootloader for the GeckOS operating system that I'm also working on.
Currently it supports 32 and 64 bit architectures, and the FAT12, 16 and FAT32 filesystems.

To run this project do:

> make ARCH_BITS=<BITS32/BITS64> FILESYSTEM=<FAT12/FAT16/FAT32> run

By default,
> make run

will use BITS32 and FAT12 flags.
