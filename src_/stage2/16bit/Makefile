
ASM_SRCS =$(shell find . -mindepth 1 -type f -name "*.S")
ASM_OBJS =$(patsubst %.S,$(OBJ_DIR)/%.o,$(notdir $(ASM_SRCS)))

vpath %.S $(STAGE2_INCLUDE_DIRS)

16bit: $(ASM_OBJS)


$(ASM_OBJS): $(OBJ_DIR)/%.o: %.S
	$(ASM) $(ASM_FLAGS) \
	$(DEFINES) \
	$(STAGE2_INCLUDES_ASM) \
	$< -o $@
	@echo ""
