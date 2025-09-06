LINKER_SCRIPT := $(STAGE2_DIR)/stage2.ld

# Use foreach loops to find source files in the specified ARCH_DIRS.
SUBDIR_ASM_SRCS := $(foreach dir,$(ARCH_DIRS),$(wildcard $(dir)/*.S))
SUBDIR_C_SRCS   := $(foreach dir,$(ARCH_DIRS),$(wildcard $(dir)/*/*.c))

# Correctly define the object file lists with a flattened structure.
# We use 'notdir' to get only the filenames, then prepend the object directory.
SUBDIR_C_OBJS := $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(SUBDIR_C_SRCS)))
SUBDIR_ASM_OBJS := $(patsubst %.S,$(OBJ_DIR)/%.o,$(notdir $(SUBDIR_ASM_SRCS)))

ALL_OBJS   := $(SUBDIR_ASM_OBJS) $(SUBDIR_C_OBJS)

.PHONY: build debug stats

stage2: $(STAGE2_BIN)
	$(call bin_size_stat, $(STAGE2_BIN))

debug: $(STAGE2_BIN)
	$(foreach dir,$(ARCH_DIRS),$(MAKE) -C $(dir) debug FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS) KERNEL_NAME="$(KERNEL_NAME)" PROJECT=$(PROJECT))

	$(OBJ_DMP) $(OBJ_DMP__FLAGS) $(STAGE2_ELF) > $(DEBUG_DIR)/stage2_elf.dump
	$(DISASM) -b 32 -o 0x0 $(STAGE2_BIN) > $(DEBUG_DIR)/stage2_bin.dump


stats: $(STAGE2_BIN)
    $(call bin_size_stat, $(STAGE2_BIN))

subdirs:
	@echo ""
	@echo ""
	@echo ""
	@echo ""
	@echo ""
	@echo ""
	@echo "$(SUBDIR_ASM_SRCS)"
	@echo ""
	@echo "$(SUBDIR_C_SRCS)"
	@echo ""
	@echo "$(SUBDIR_C_OBJS)"
	@echo ""
	@echo "$(SUBDIR_ASM_OBJS)"
	@echo ""
	@echo "$(ALL_OBJS)"
	@echo ""
	@echo ""
	@echo ""
	@echo ""
	@echo ""
	@echo ""
# Build all object files from the subdirectories
	$(foreach dir,$(ARCH_DIRS),$(MAKE) -C $(dir) build FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS) KERNEL_NAME="$(KERNEL_NAME)" PROJECT=$(PROJECT) && echo "";)

# Build Rules

# Link all object files into the final ELF executable
$(STAGE2_ELF): subdirs $(ALL_OBJS) $(LINKER_SCRIPT)
	$(LD) $(LD_FORMAT) $(LD_FLAGS) $(ALL_OBJS) -T $(LINKER_SCRIPT) -o $@

# Convert the ELF executable to a raw binary
$(STAGE2_BIN): $(STAGE2_ELF)
	$(OBJ_CPY) $(OBJ_CPY_FLAGS) $< $@
