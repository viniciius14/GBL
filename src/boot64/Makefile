include $(PROJECT)/misc/config.mk

ASM_SRCS := setup64Mode.S \
	cpuid.S \
	extended_functions.S \
	compatibility_mode.S \
	paging.S

ASM_INCLUDE_DIRS := $(BOOT64_DIR)/setup64Mode

C_SRCS :=

C_INCLUDE_DIRS :=

ASM_INCLUDES :=$(foreach dir,$(ASM_INCLUDE_DIRS),-I $(dir))
C_INCLUDES   :=$(foreach dir,$(C_INCLUDE_DIRS),-I $(dir))

$(foreach dir,$(C_INCLUDE_DIRS),$(eval vpath %.c $(dir)))
$(foreach dir,$(ASM_INCLUDE_DIRS),$(eval vpath %.S $(dir)))


# ASM and C SRCS will now contain <dir>/filename.<S/c>, so remove the dir to not
# screw up the OBJS path (would be OBJ_DIR64/<dir>/filename.o and we want OBJ_DIR64/filename.o)
ASM_OBJS :=$(patsubst %.S,$(OBJ_DIR64)/%.o,$(notdir $(ASM_SRCS)))
C_OBJS   :=$(patsubst %.c,$(OBJ_DIR64)/%.o,$(notdir $(C_SRCS)))

TARGET_OBJ := $(OBJ_DIR64)/boot64_all.o

.PHONY: boot64 clean

boot64: libs $(TARGET_OBJ)
	@echo -n "Boot64 size in bytes: " >> $(STATS_FILE)
# 	@wc -c < $(TARGET_BIN) >> $(STATS_FILE)
	@echo ""
	@echo "--- Boot64 Build Complete ---"
	@echo ""

libs:
ifeq ($(ARCH_BITS), BITS64)
	$(MAKE) -C $(COMMON_DIR)/libs libs64
endif

# $(TARGET_BIN): $(TARGET_OBJ)
# 	$(OBJ_CPY) -O binary $< $@

$(TARGET_OBJ): $(ASM_OBJS) $(C_OBJS)
	$(LD) -r $(OBJ_DIR64)/*.o -o $@
# 	$(LD) $(LD_FLAGS) $(LD_FORMAT64) $(OBJ_DIR64)/*.o -T linker.ld  -o $@
	$(OBJ_DMP) $(OBJ_DMP_FLAGS) $@ > $(DEBUG_DIR)/boot64_all.S

$(OBJ_DIR64)/%.o: %.S
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT64) \
	$(ASM_INCLUDES) \
	$(USER_INPUTS) \
	$< -o $@ -l $(DEBUG_DIR64)/$(basename $(notdir $@)).S
	@echo ""
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT64) \
	$(ASM_INCLUDES) \
	$(USER_INPUTS) \
	$< -E > $(DEBUG_DIR64)/$(basename $(notdir $@)).S
	@echo ""

$(OBJ_DIR64)/%.o: %.c
	$(CC64) $(CC_FLAGS) \
	$(USER_INPUTS) \
	$(C_INCLUDES) \
	-c $< -o $@
	@echo ""
