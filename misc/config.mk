# Directories
export BUILD_DIR   :=$(PROJECT)/build
export DOCS_DIR    :=$(PROJECT)/docs
export MISC_DIR    :=$(PROJECT)/misc
export SRC_DIR     :=$(PROJECT)/src

export BIN_DIR     :=$(BUILD_DIR)/bin
export OBJ_DIR     :=$(BUILD_DIR)/obj
export DEBUG_DIR   :=$(BUILD_DIR)/debug
export STATS_FILE  :=$(BUILD_DIR)/stats.log

export OBJ_DIR32   :=$(OBJ_DIR)/32
export OBJ_DIR64   :=$(OBJ_DIR)/64
export OBJ_DIR_COMMON:=$(OBJ_DIR)/common

export DEBUG_DIR16 :=$(DEBUG_DIR)/16
export DEBUG_DIR32 :=$(DEBUG_DIR)/32
export DEBUG_DIR64 :=$(DEBUG_DIR)/64

export SCRIPTS_DIR :=$(MISC_DIR)/scripts

export BIOS_DIR    :=$(SRC_DIR)/firmware/BIOS
export BOOT16_DIR  :=$(SRC_DIR)/boot16
export BOOT32_DIR  :=$(SRC_DIR)/boot32
export BOOT64_DIR  :=$(SRC_DIR)/boot64
export FIRMWARE_DIR:=$(SRC_DIR)/firmware

export COMMON_DIR  :=$(SRC_DIR)/common

export DRIVERS_DIR :=$(COMMON_DIR)/drivers
export LIBS_DIR	   :=$(COMMON_DIR)/libs

export DISK_DIR	   :=$(DRIVERS_DIR)/disk
export VIDEO_DIR   :=$(DRIVERS_DIR)/video
export FS_DIR      :=$(DRIVERS_DIR)/filesystem


# Targets
export BOOT16 =$(BIN_DIR)/boot16.bin
export BOOT32 =$(BIN_DIR)/boot32.bin
export BOOT64 =$(BIN_DIR)/boot64.bin

# This current file
export CONFIG_FILE :=$(MISC_DIR)/config.mk

# Tools
export ASM        =nasm
export CC         =i386-elf-gcc
export CC64       =x86_64-elf-gcc
export LD         =ld
export OBJ_CPY    =objcopy
export OBJ_DMP    =objdump
export DISASM     =ndisasm
export EMULATOR32:=qemu-system-i386
export EMULATOR64:=qemu-system-i386 # TODO: CHANGE ME!

# Flags
export ASM_FLAGS     =-W+all -W+error -W+orphan-labels -W+macro-params
export ASM_FORMAT32  =-f elf32
export ASM_FORMAT64  =-f elf64
export CC_FLAGS      =-Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mgeneral-regs-only -fdata-sections -ffunction-sections -pedantic -std=c11
export CC_FORMAT     =-m32
export LD_FLAGS      =--gc-sections
export LD_FORMAT     =-m elf_i386
export LD_FORMAT64   =-m elf_x86_64
export OBJ_CPY_FLAGS =-O binary
export OBJ_DMP_FLAGS =-D --visualize-jumps --start-address=0x7E00
export EMUL_FLAGS    =-m 128M -serial stdio -machine pc
export FS_FAT12_ARGS =-a -F 12 -S 512 -s 1 -r 224 -R 1
export FS_FAT16_ARGS =-a -F 16 -S 512 -s 8 -r 512 -R 4
export FS_FAT32_ARGS =-a -F 32 -S 512 -s 4        -R 32

# Extra stuff for the build process
export USER_INPUTS       =-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"'

export COMMON_LIBS  :=$(foreach dir,$(shell find $(LIBS_DIR) -mindepth 1 -type d),$(dir))