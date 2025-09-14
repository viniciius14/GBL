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

# Targets
# Leave these as = since only later will we know what FILE_SYSTEM and ARCH_BITS are
export STAGE1_BIN   =$(BIN_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).bin
export STAGE2_BIN   =$(BIN_DIR)/stage2_$(FILE_SYSTEM)_$(ARCH_BITS).bin
export STAGE2_ELF   =$(OBJ_DIR)/stage2_$(FILE_SYSTEM)_$(ARCH_BITS).elf

# This current file
export CONFIG_FILE :=$(MISC_DIR)/config.mk

# Tools
export ASM      =nasm
export CC       =x86_64-elf-gcc
export LD       =ld
export OBJ_CPY  =objcopy
export OBJ_DMP  =objdump
export DISASM   =ndisasm
export EMULATOR =qemu-system-i386

# Flags
export ASM_FLAGS     =-W+all -W+error -W+orphan-labels -W+macro-params $(ASM_FORMAT)
export ASM_FORMAT    =-f elf32
export CC_FLAGS      =-Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mgeneral-regs-only -fdata-sections -ffunction-sections -pedantic -std=c11 $(CC_FORMAT)
export CC_FORMAT     =-m32
export LD_FLAGS      =--gc-sections $(LD_FORMAT)
export LD_FORMAT     =-m elf_i386
export OBJ_CPY_FLAGS =-O binary
export OBJ_DMP_FLAGS =-D --visualize-jumps --start-address=0x7E00
export EMUL_FLAGS    =-m 128M -serial stdio -machine pc
export FS_FAT12_ARGS =-a -F 12 -S 512 -s 1 -r 224 -R 1
export FS_FAT16_ARGS =-a -F 16 -S 512 -s 8 -r 512 -R 4
export FS_FAT32_ARGS =-a -F 32 -S 512 -s 4        -R 32

# Extra stuff for the build process
# export DEFINES   		    =-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"'
export DEFINES   		    =-D$(FILE_SYSTEM) -DBITS32 -DKERNEL_NAME='"$(KERNEL_NAME)"'
# The superfluous wildcards are only here for future proofing sake
export DEFAULT_INCLUDE_DIRS :=$(SRC_DIR)/BIOS $(wildcard $(SRC_DIR)/BIOS/*/)
export DEFAULT_INCLUDE_DIRS +=$(SRC_DIR)/common $(wildcard $(SRC_DIR)/common/*/)
export DEFAULT_INCLUDE_DIRS +=$(SRC_DIR)/filesystems $(wildcard $(SRC_DIR)/filesystems/*/)
export DEFAULT_INCLUDE_DIRS +=$(STAGE1_DIR)

export ARCH_DIRS =$(STAGE2_DIR)/16bit $(STAGE2_DIR)/32bit

