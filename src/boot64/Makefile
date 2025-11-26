include $(PROJECT)/misc/config.mk

ASM_SRCS := setup64Mode.S \
	boot64.S \
	cpuid.S \
	extended_functions.S \
	compatibility_mode.S \
	paging.S

ASM_INCLUDE_DIRS := $(BOOT64_DIR)/setup64Mode

ASM_INCLUDES :=$(foreach dir,$(ASM_INCLUDE_DIRS),-I $(dir))

$(foreach dir,$(ASM_INCLUDE_DIRS),$(eval vpath %.S $(dir)))

# ASM and C SRCS will now contain <dir>/filename.<S/c>, so remove the dir to not
# screw up the OBJS path (would be OBJ_DIR64/<dir>/filename.o and we want OBJ_DIR64/filename.o)
ASM_OBJS :=$(patsubst %.S,$(OBJ_DIR64)/%.o,$(notdir $(ASM_SRCS)))

TARGET_OBJ := $(OBJ_DIR64)/boot64_all.o

.PHONY: boot64

boot64: $(ASM_OBJS)
	@echo -n "Boot64 size in bytes: " >> $(STATS_FILE)
# TODO
# 	@wc -c < $(TARGET_BIN) >> $(STATS_FILE)
	@echo ""
	@echo "--- Boot64 Build Complete ---"
	@echo ""

$(OBJ_DIR64)/%.o: %.S
	@echo ""
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT64) \
	$(ASM_INCLUDES) \
	$(USER_INPUTS) \
	-l $(DEBUG_DIR64)/$(basename $(notdir $@))_lst.S \
	$< -o $@

	@$(ASM) $(ASM_FLAGS) $(ASM_FORMAT64) \
	$(ASM_INCLUDES) \
	$(USER_INPUTS) \
	$< -E > $(DEBUG_DIR64)/$(basename $(notdir $@))_dbg.S
