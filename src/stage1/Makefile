# Define the source file for stage 1 of the bootloader
ASM_SRC    =stage1.S
ASM_FORMAT =-f bin

STAGE1_INLCUDE_DIRS =$(SRC_DIR)/BIOS
STAGE1_INLCUDE_DIRS+=$(SRC_DIR)/common
STAGE1_INLCUDE_DIRS+=$(SRC_DIR)/filesystems $(wildcard $(SRC_DIR)/filesystems/*/)

STAGE1_INLCUDES     =$(foreach dir,$(STAGE1_INLCUDE_DIRS),-i $(dir))


# Define debug output paths
# STAGE1_DEBUG_I    = $(DEBUG_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).i
# STAGE1_DEBUG_LST  = $(DEBUG_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).lst
# STAGE1_DEBUG_DUMP = $(DEBUG_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).dump

.PHONY: stage1 debug stats


stage1: $(STAGE1_BIN)
	wc -c < $(STAGE1_BIN) >> $(STATS_FILE)

debug: $(STAGE1_BIN)
	@echo "Generating debug artifacts for stage1..."
# Generate preprocessed output (.i file)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(GBL_INCLUDES) \
	$(ASM_SRC) -E > $(STAGE1_DEBUG_I)
# Generate listing file (.lst) and re-assemble (if not already done by build)
# This re-runs assembly to include the listing output.
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(GBL_INCLUDES) \
	$(ASM_SRC) -l $(STAGE1_DEBUG_LST) -o $(STAGE1_BIN)
# Generate disassembly dump using ndisasm
	ndisasm -b 16 -o 0x7C00 $(STAGE1_BIN) > $(STAGE1_DEBUG_DUMP)
	@echo "Debug artifacts generated in $(DEBUG_DIR):"
	@echo "  - $(STAGE1_DEBUG_I)"
	@echo "  - $(STAGE1_DEBUG_LST)"
	@echo "  - $(STAGE1_DEBUG_DUMP)"


stats: $(STAGE1_BIN)



# Build rules
$(STAGE1_BIN): $(ASM_SRC)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(STAGE1_INLCUDES) \
	$< -o $@
