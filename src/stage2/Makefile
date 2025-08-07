include $(CONFIG_FILE)

LINKER_SCRIPT := $(STAGE2_DIR)/stage2.ld
MAIN_ASM_SRC  := $(STAGE2_DIR)/load_kernel.S
MAIN_ASM_OBJ  := $(OBJ_DIR)/load_kernel_$(ARCH_BITS).o

ifeq ($(ARCH_BITS), BITS32)
	ARCH_DIRS      := $(STAGE2_DIR)/16bit $(STAGE2_DIR)/32bit
else
	ARCH_DIRS      := $(STAGE2_DIR)/16bit $(STAGE2_DIR)/32bit $(STAGE2_DIR)/64bit
	ASM_FORMAT      =-f elf64
	LD_FORMAT       =-m elf_x86_64
endif

SUBDIR_ASM_SRCS := $(foreach dir,$(ARCH_DIRS),$(wildcard $(dir)/*.S))
SUBDIR_C_SRCS   := $(foreach dir,$(ARCH_DIRS),$(wildcard $(dir)/*.c))

SUBDIR_ASM_OBJS := $(foreach dir,$(ARCH_DIRS),\
                   $(patsubst $(dir)/%.S,$(OBJ_DIR)/%.o,$(wildcard $(dir)/*.S)))
SUBDIR_C_OBJS   := $(foreach dir,$(ARCH_DIRS),\
                   $(patsubst $(dir)/%.c,$(OBJ_DIR)/%.o,$(wildcard $(dir)/*.c)))

ALL_OBJS   := $(SUBDIR_ASM_OBJS) $(SUBDIR_C_OBJS) $(MAIN_ASM_OBJ)

.PHONY: build debug stats

build: $(STAGE2_BIN)


debug: $(STAGE2_BIN)
	$(foreach dir,$(ARCH_DIRS),$(MAKE) -C $(dir) debug FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS) KERNEL_NAME="$(KERNEL_NAME)" PROJECT=$(PROJECT))

	$(OBJ_DMP) $(OBJ_DMP__FLAGS) $(STAGE2_ELF) > $(DEBUG_DIR)/stage2_elf.dump
	$(DISASM) -b 32 -o 0x0 $(STAGE2_BIN) > $(DEBUG_DIR)/stage2_bin.dump


stats: $(STAGE2_BIN)
	$(call bin_size_stat, $(STAGE2_BIN))

subdirs:
# Build all object files from the subdirectories
	$(foreach dir,$(ARCH_DIRS),$(MAKE) -C $(dir) build FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS) KERNEL_NAME="$(KERNEL_NAME)" PROJECT=$(PROJECT);)

# Build Rules

# Build the object file(s) from the current directory
$(MAIN_ASM_OBJ): $(MAIN_ASM_SRC)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(GBL_INCLUDES) \
	$< -o $@

# Link all object files into the final ELF executable
$(STAGE2_ELF): subdirs $(ALL_OBJS) $(LINKER_SCRIPT)
	$(LD) $(LD_FORMAT) $(LD_FLAGS) $(ALL_OBJS) -T $(LINKER_SCRIPT) -o $@

# Convert the ELF executable to a raw binary
$(STAGE2_BIN): $(STAGE2_ELF)
	$(OBJ_CPY) $(OBJ_CPY_FLAGS) $< $@
