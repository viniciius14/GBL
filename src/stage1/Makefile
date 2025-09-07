# TODO: having this include here is a patch for ASM_FORMAT not updating to -f bin
include $(PROJECT)/misc/config.mk

# Define sources
ASM_SRC    =stage1.S

# Override this flag as this "sub project" is directly compiled to a binary
ASM_FORMAT =-f bin

# Get directories to include
STAGE1_INCLUDE_DIRS =$(DEFAULT_INCLUDE_DIRS)
STAGE1_INCLUDES     =$(foreach dir,$(STAGE1_INCLUDE_DIRS),-i $(dir))

# Debug targets
DEBUG_I    =$(DEBUG_DIR)/stage1.i
DEBUG_LST  =$(DEBUG_DIR)/stage1.lst
DEBUG_DUMP =$(DEBUG_DIR)/stage1.dump


.PHONY: stage1 debug

stage1: $(STAGE1_BIN)
	wc -c < $(STAGE1_BIN) >> $(STATS_FILE)


debug: $(DEBUG_I) $(DEBUG_LST) $(DEBUG_DUMP)
# Finally, generate a debug build of the file (ie just add the debug define)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	$(DEFINES) -DDEBUG \
	$(STAGE1_INCLUDES) \
	$< -o $@


# Generate preprocessed output (.i file)
$(DEBUG_I): $(ASM_SRC)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	$(DEFINES) \
	$(STAGE1_INCLUDES) \
	$(ASM_SRC) -E > $(STAGE1_DEBUG_I)


# Generate listing file (.lst)
$(DEBUG_LST): $(ASM_SRC)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	$(DEFINES) \
	$(STAGE1_INCLUDES) \
	$(ASM_SRC) -l $(STAGE1_DEBUG_LST) -o $(STAGE1_BIN)


# Generate disassembly dump
$(DEBUG_DUMP): $(STAGE1_BIN)
	$(DISASM) -b 16 -o 0x7C00 $(STAGE1_BIN) > $(STAGE1_DEBUG_DUMP)


# Build rules
$(STAGE1_BIN): $(ASM_SRC)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	$(DEFINES) \
	$(STAGE1_INCLUDES) \
	$< -o $@
	@echo ""
