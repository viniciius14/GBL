# Constants for the build system
# Directories
export BUILD_DIR   := $(PROJECT)/build
export DOCS_DIR    := $(PROJECT)/docs
export MISC_DIR    := $(PROJECT)/misc
export SRC_DIR     := $(PROJECT)/src

export BIN_DIR     := $(BUILD_DIR)/bin
export OBJ_DIR     := $(BUILD_DIR)/obj
export DEBUG_DIR   := $(BUILD_DIR)/debug
export STATS_FILE  := $(BUILD_DIR)/stats.log

export SCRIPTS_DIR := $(MISC_DIR)/scripts

export BIOS_DIR    := $(SRC_DIR)/BIOS
export COMMON_DIR  := $(SRC_DIR)/common
export FS_DIR      := $(SRC_DIR)/filesystems
export STAGE1_DIR  := $(SRC_DIR)/stage1
export STAGE2_DIR  := $(SRC_DIR)/stage2

# Tools
export ASM=nasm
export CC=i386-elf-gcc
export LD=ld
export OBJ_CPY=i386-elf-objcopy
export EMULATOR=qemu-system-i386

# Flags
export ASM_FLAGS=-W+all -W+error -W+orphan-labels -W+macro-params
export ASM_FORMAT=-f elf32

export CC_FLAGS=-m32 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mgeneral-regs-only -fdata-sections -ffunction-sections -std=c11

export LD_FLAGS=--gc-sections -m elf_i386
export LD_FORMAT=-m elf_i386

export OBJ_CPY_FLAGS=-O binary

export EMUL_FLAGS=-m 128M -serial stdio -machine pc
