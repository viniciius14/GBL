include $(PROJECT)/misc/config.mk

ASM_SRCS := boot32.S \
	setup32Mode.S \
	A20.S

ASM_INCLUDE_DIRS := $(BOOT32_DIR)/setup32Mode

# C_SRCS := vga.c \
# 	logo.c

# C_INCLUDE_DIRS := \
# 	$(BOOT32_DIR)/logo \
# 	$(VIDEO_DIR) \
# 	$(COMMON_LIBS)

ASM_INCLUDES :=$(foreach dir,$(ASM_INCLUDE_DIRS),-I $(dir))
# C_INCLUDES   :=$(foreach dir,$(C_INCLUDE_DIRS),-I $(dir))

$(foreach dir,$(C_INCLUDE_DIRS),$(eval vpath %.c $(dir)))
$(foreach dir,$(ASM_INCLUDE_DIRS),$(eval vpath %.S $(dir)))

# ASM and C SRCS will now contain <dir>/filename.<S/c>, so remove the dir to not
# screw up the OBJS path (would be OBJ_DIR32/<dir>/filename.o and we want OBJ_DIR32/filename.o)
ASM_OBJS :=$(patsubst %.S,$(OBJ_DIR32)/%.o,$(notdir $(ASM_SRCS)))
# C_OBJS   :=$(patsubst %.c,$(OBJ_DIR32)/%.o,$(notdir $(C_SRCS)))

TARGET_OBJ := $(OBJ_DIR32)/boot32_all.o
# TARGET_BIN := $(BOOT32)

ifeq ($(ARCH_BITS), BITS32)
CURR_ASM_FORMAT := $(ASM_FORMAT32)
# CURR_CC := $(CC)
CURR_LD_FORMAT := $(LD_FORMAT)
else
CURR_ASM_FORMAT := $(ASM_FORMAT64)
# CURR_CC := $(CC64)
CURR_LD_FORMAT := $(LD_FORMAT64)
endif

.PHONY: boot32

boot32: libs $(TARGET_OBJ)
	@echo -n "Boot32 size in bytes: " >> $(STATS_FILE)
# 	@wc -c < $(TARGET_BIN) >> $(STATS_FILE)
	@echo ""
	@echo "--- Boot32 Build Complete ---"
	@echo ""

libs:
ifeq ($(ARCH_BITS), BITS32)
	$(MAKE) -C $(COMMON_DIR)/libs libs32
endif

# $(TARGET_BIN): $(TARGET_OBJ)
# 	$(OBJ_CPY) $(OBJ_CPY_FLAGS) $< $@

$(TARGET_OBJ): $(ASM_OBJS) # $(C_OBJS)
	$(LD) -r $(CURR_LD_FORMAT) $(OBJ_DIR32)/*.o -o $@
	$(OBJ_DMP) $(OBJ_DMP_FLAGS) $@ > $(DEBUG_DIR)/boot32_all.S

$(ASM_OBJS): $(OBJ_DIR32)/%.o: %.S
	$(ASM) $(ASM_FLAGS) $(CURR_ASM_FORMAT) \
	$(ASM_INCLUDES) \
	$(USER_INPUTS) \
	$< -o $@ -l $(DEBUG_DIR32)/$(basename $(notdir $@)).S
	@echo ""
	$(ASM) $(ASM_FLAGS) $(CURR_ASM_FORMAT) \
	$(ASM_INCLUDES) \
	$(USER_INPUTS) \
	$< -E > $(DEBUG_DIR32)/$(basename $(notdir $@)).S
	@echo ""

# $(C_OBJS) : $(OBJ_DIR32)/%.o: %.c
# 	$(CURR_CC) $(CC_FLAGS) \
# 	$(USER_INPUTS) \
# 	$(C_INCLUDES) \
# 	-c $< -o $@
# 	@echo ""
