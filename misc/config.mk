# Constants for the build system
# Directories
export BUILD_DIR   :=$(PROJECT)/build
export DOCS_DIR    :=$(PROJECT)/docs
export MISC_DIR    :=$(PROJECT)/misc
export SRC_DIR     :=$(PROJECT)/src

export BIN_DIR     :=$(BUILD_DIR)/bin
export OBJ_DIR     :=$(BUILD_DIR)/obj
export DEBUG_DIR   :=$(BUILD_DIR)/debug
export STATS_FILE  :=$(BUILD_DIR)/stats.log

export SCRIPTS_DIR :=$(MISC_DIR)/scripts

export BIOS_DIR    :=$(SRC_DIR)/BIOS
export COMMON_DIR  :=$(SRC_DIR)/common
export FS_DIR      :=$(SRC_DIR)/filesystems
export STAGE1_DIR  :=$(SRC_DIR)/stage1
export STAGE2_DIR  :=$(SRC_DIR)/stage2

# These need to get reevaluated so leave them just with the "="
export STAGE1_BIN   =$(BIN_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).bin
export STAGE2_BIN   =$(BIN_DIR)/stage2_$(FILE_SYSTEM)_$(ARCH_BITS).bin
export STAGE2_ELF   =$(OBJ_DIR)/stage2_$(FILE_SYSTEM)_$(ARCH_BITS).elf

# This current file
export CONFIG_FILE :=$(MISC_DIR)/config.mk

# Tools
export ASM      :=nasm
export CC       :=i386-elf-gcc
export LD       :=ld
export OBJ_CPY  :=objcopy
export OBJ_DMP  :=objdump
export DISASM   :=ndisasm
export EMULATOR :=qemu-system-i386

# Flags
export ASM_FLAGS     :=-W+all -W+error -W+orphan-labels -W+macro-params
export ASM_FORMAT    :=-f elf32
export CC_FLAGS      :=-Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mgeneral-regs-only -fdata-sections -ffunction-sections -pedantic -std=c11
export CC_FORMAT     :=-m32
export LD_FLAGS      :=--gc-sections
export LD_FORMAT     :=-m elf_i386
export OBJ_CPY_FLAGS :=-O binary
export OBJ_DMP_FLAGS :=-D --visualize-jumps --start-address=0x7E00
export EMUL_FLAGS    :=-m 128M -serial stdio -machine pc
export FS_FAT12_ARGS :=-a -F 12 -S 512 -s 1 -r 224 -R 1
export FS_FAT16_ARGS :=-a -F 16 -S 512 -s 8 -r 512 -R 4
export FS_FAT32_ARGS :=-a -F 32 -S 512 -s 4        -R 32
