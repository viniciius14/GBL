include $(CONFIG_FILE)

LINKER_SCRIPT := $(STAGE2_DIR)/stage2.ld
MAIN_ASM_SRC  := $(STAGE2_DIR)/load_kernel.S
MAIN_ASM_OBJ  := $(OBJ_DIR)/load_kernel_$(ARCH_BITS).o
# TODO update this so that it automatically decides which dirs to include
ARCH_DIR      := $(STAGE2_DIR)/32bit

SUBDIR_C_SRCS   := $(wildcard $(ARCH_DIR)/*.c)
SUBDIR_ASM_SRCS := $(wildcard $(ARCH_DIR)/*.S)

SUBDIR_C_OBJS   := $(patsubst $(ARCH_DIR)/%.c,$(OBJ_DIR)/$(ARCH_BITS)_%.o,$(SUBDIR_C_SRCS))
SUBDIR_ASM_OBJS := $(patsubst $(ARCH_DIR)/%.S,$(OBJ_DIR)/$(ARCH_BITS)_%.o,$(SUBDIR_ASM_SRCS))

ALL_OBJS   := $(SUBDIR_C_OBJS) $(SUBDIR_ASM_OBJS) $(MAIN_ASM_OBJ)

STAGE2_ELF := $(OBJ_DIR)/stage2_$(ARCH_BITS).elf
STAGE2_BIN := $(BIN_DIR)/stage2_$(ARCH_BITS).bin

.PHONY: all build debug clean stats

build: $(STAGE2_BIN)


debug: $(STAGE2_BIN) | $(DEBUG_DIR)
	$(MAKE) -C $(ARCH_DIR) debug \
	FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS) KERNEL_NAME='"$(KERNEL_NAME)"' \
	PROJECT=$(PROJECT)

	objdump -D --visualize-jumps --start-address=0x7E00 $(STAGE2_ELF) > $(DEBUG_DIR)/stage2_$(ARCH_BITS)_elf.dump
	ndisasm -b 32 -o 0x0 $(STAGE2_BIN) > $(DEBUG_DIR)/stage2_$(ARCH_BITS)_bin.dump # Note: Adjusted offset and bitness for 32-bit binary

stats: $(STAGE2_BIN)
	$(call bin_size_stat, $(STAGE2_BIN))


# Build Rules

# Build all object files from the subdirectories
$(SUBDIR_C_OBJS) $(SUBDIR_ASM_OBJS): | $(OBJ_DIR)
	$(MAKE) -C $(ARCH_DIR) build \
	FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS) KERNEL_NAME='"$(KERNEL_NAME)"' \
	PROJECT=$(PROJECT)


# Build the object file(s) from the current directory
$(MAIN_ASM_OBJ): $(MAIN_ASM_SRC) | $(OBJ_DIR)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(GBL_INCLUDES) \
	$< -o $@

# Link all object files into the final ELF executable
$(STAGE2_ELF): $(ALL_OBJS) $(LINKER_SCRIPT) | $(OBJ_DIR)
	$(LD) $(LD_FLAGS) -T $(LINKER_SCRIPT) -o $@ $(ALL_OBJS)

# Convert the ELF executable to a raw binary
$(STAGE2_BIN): $(STAGE2_ELF) | $(BIN_DIR)
	$(OBJ_CPY) $(OBJ_CPY_FLAGS) $< $@

$(BIN_DIR) $(OBJ_DIR) $(DEBUG_DIR):
	mkdir -p $@
