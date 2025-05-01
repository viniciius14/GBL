# Directories
PROJECT=/root/projects/GBL

BUILD_DIR=$(PROJECT)/build
DOCS_DIR=$(PROJECT)/docs
MISC_DIR=$(PROJECT)/misc
SRC_DIR=$(PROJECT)/src

BIN_DIR=$(BUILD_DIR)/bin
OBJ_DIR=$(BUILD_DIR)/obj
DEBUG_DIR=$(BUILD_DIR)/debug

STATS=$(BUILD_DIR)/stats.log

ASM=nasm
ASM_FORMAT=-f elf32

CC=i386-elf-gcc
CC_FLAGS=-m32 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mgeneral-regs-only -fdata-sections -ffunction-sections -std=c11

LD=ld
LD_FLAGS=--gc-sections -m elf_i386
LD_FORMAT=-m elf_i386

OBJ_CPY=i386-elf-objcopy
OBJ_FLAGS=-O binary

EMULATOR=qemu-system-i386
EMUL_FLAGS=-m 128M -serial stdio

