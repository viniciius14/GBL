# Makefile

This project uses makefiles exclusively to build the different images that GBL supports.

The tools used by the makefiles are as follows:
```
nasm    - To assemble the assembly files.
gcc     - To compile C files (depending on the selected bit architecture it'll be either i386-elf-gcc or your "regular" gcc).
ld      - To link the generated .o files.
objcopy - To extract a binary file from the generated elfs'.

dd      -
dosfstools -

qemu    - To emulate the generated images. (depending on the selected bit architecture it'll be either qemu-system-i386 or qemu-system-x86_64).

gdb     - To debug.
objdump - To help with debugging.
ndisasm - To help with debugging.
```
If you'd like to avoid installing all of these tools you can run:
```
. misc/scripts/docker.sh
```
Which will create and run a container where these tools are already installed for you.

To specify a specific file system, bit architecture or kernel name, that can be inputted into the makefile like so:
```
make FILE_SYSTEM=FAT12 ARCH_BITS=BITS32 KERNEL_NAME="KERNEL  BIN"
```
> Make sure that the string passed into **KERNEL_NAME is exactly 11 characters long** for FAT filesystems!

The currently available options are as follows:
```
FILE_SYSTEM = FAT12, FAT16 & FAT32
ARCH_BITS   = BITS32 & BITS64
KERNEL_NAME = <Any 11 character binary>
```
If no options are specified the default values are:
```
FILE_SYSTEM = FAT12
ARCH_BITS   = BITS32
KERNEL_NAME = KERNEL  BIN
```

## Targets
```
GBL   - Builds an image.
all   - Builds all possible images supported by GBL.
run   - Builds an image and then uses QEMU to emulate it.
debug - Builds an image with debug flags and generates helper files.
stats - Builds an image and writes the size of the binaries into build/stats.log.
clean - Deletes the build/ directory.
```

## Structure

The main Makefile defines the project base directory, variables that are gonna be used (includes [config.mk](../misc/config.mk)), defines "dynamic" variables, and is responsible for the final image building if everything gets compiled.\
It then calls the [Stage1/Makefile](../src/stage1/Makefile) and [Stage2/Makefile](../src/stage2/Makefile).

### Stage1

[Stage1/Makefile](../src/stage1/Makefile) is a bit different then all other Makefiles as we need to compile our code directly into a 512 byte flat binary and therefore it's more simple to read. For FAT32 the resulting binary will be 1024 bytes. (More about this [here](Stage1.md)).

### Stage2

[Stage2/Makefile](../src/stage2/Makefile) is an orchestrator which itself only compiles one file. It's main job is to call the Makefiles in the correct subdirectories and extract a binary from the generated .o files.\
Here comes into play the diffrences between BITS32 and BITS64 used in the initial Makefile call. If the bit architecture selected was BITS32 then only [16bit/Makefile](../src/stage2/16bit/Makefile) and [32bit/Makefile](../src/stage2/32bit/Makefile) will be used, however if BITS64 was selected then [64bit/Makefile](../src/stage2/64bit/Makefile) is also used.\


## Flags
This section is an explination of what flags are used and why. This serves as a way to explain them, make sure I understand them and to spot any inconsistencies/missing flags.\
**WIP**

### nasm
```
W+all - 
W+error - 
W+orphan-labels - 
W+macro-params - 
f - <elf32>
```
### gcc
```
Wall - 
Wextra - 
Werror - 
nostdlib - 
fno-builtin - 
ffreestanding - 
mgeneral-regs-only - 
fdata-sections - 
ffunction-sections - 
pedantic - 
std= - <c11>
m32 - 
```
### ld
```
gc-sections - 
m - <elf_i386>
```
### qemu
```
m - <128M>
serial - <stdio>
machine - <pc>
```
### mkfs.fat
```
a - 
S - <512>
F - <12/16/32>
s - <1/8/4>
r - <224/512>
R - <1/4>
```
