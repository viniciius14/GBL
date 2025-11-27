include $(PROJECT)/misc/config.mk

ASM_SRCS := boot32.S \
	setup32Mode.S \
	A20.S

ASM_INCLUDE_DIRS := $(BOOT32_DIR)/setup32Mode

ASM_INCLUDES :=$(foreach dir,$(ASM_INCLUDE_DIRS),-I $(dir))

$(foreach dir,$(ASM_INCLUDE_DIRS),$(eval vpath %.S $(dir)))

# ASM and C SRCS will now contain <dir>/filename.<S/c>, so remove the dir to not
# screw up the OBJS path (would be OBJ_DIR32/<dir>/filename.o and we want OBJ_DIR32/filename.o)
ASM_OBJS :=$(patsubst %.S,$(OBJ_DIR32)/%.o,$(notdir $(ASM_SRCS)))

TARGET_OBJ := $(OBJ_DIR32)/boot32_all.o

.PHONY: boot32

boot32: $(ASM_OBJS) #libs
	@echo -n "Boot32 size in bytes: " >> $(STATS_FILE)
# 	@wc -c < $(TARGET_BIN) >> $(STATS_FILE)
	@echo ""
	@echo "--- Boot32 Build Complete ---"
	@echo ""

$(OBJ_DIR32)/%.o: %.S
	@echo ""
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) \
	$(ASM_INCLUDES) \
	$(USER_INPUTS) \
	-l $(DEBUG_DIR32)/$(basename $(notdir $@))_lst.S \
	$< -o $@

	@$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) \
	$(ASM_INCLUDES) \
	$(USER_INPUTS) \
	$< -E > $(DEBUG_DIR32)/$(basename $(notdir $@))_dbg.S
