include $(PROJECT)/misc/config.mk

ASM_SRCS := stage2_32.S

ASM_INCLUDE_DIRS :=

C_SRCS :=  vga.c \
	logo.c

C_INCLUDE_DIRS := \
    $(BOOT32_DIR)/logo \
	$(VIDEO_DIR) \
	$(COMMON_LIBS)

ASM_INCLUDES :=$(foreach dir,$(ASM_INCLUDE_DIRS),-I $(dir))
C_INCLUDES   :=$(foreach dir,$(C_INCLUDE_DIRS),-I $(dir))

# Generate vpath directives automatically
$(foreach dir,$(C_INCLUDE_DIRS),$(eval vpath %.c $(dir)))
vpath %.S $(BOOT32_DIR)


# ASM and C SRCS will now contain <dir>/filename.<S/c>, so remove the dir to not
# screw up the OBJS path (would be OBJ_DIR/<dir>/filename.o and we want OBJ_DIR/filename.o)
ASM_OBJS :=$(patsubst %.S,$(OBJ_DIR)/%.o,$(notdir $(ASM_SRCS)))
C_OBJS   :=$(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(C_SRCS)))

TARGET_ELF := $(OBJ_DIR)/boot32_$(FILE_SYSTEM)_$(ARCH_BITS).elf
TARGET_BIN := $(BOOT32)

.PHONY: boot32 clean

boot32: libs $(TARGET_BIN)
	@echo -n "Boot32 size in bytes: " >> $(STATS_FILE)
	@wc -c < $(TARGET_BIN) >> $(STATS_FILE)
	@echo ""
	@echo "--- Boot32 Build Complete ---"
	@echo ""

libs:
	$(MAKE) -C $(COMMON_DIR)/libs

$(TARGET_BIN): $(TARGET_ELF)
	$(OBJ_CPY) -O binary $< $@

# Not the greatest, we're adding all files in the obj dir to the output.
# Should be okay because we cull not called files
$(TARGET_ELF): $(ASM_OBJS) $(C_OBJS)
	$(LD) $(LD_FLAGS) $(OBJ_DIR)/*.o -T linker.ld $(LD_FORMAT) -o $@

$(ASM_OBJS): $(OBJ_DIR)/%.o: %.S
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) \
	$(ASM_INCLUDES) \
	$(INPUTS) \
	$< -o $@
	@echo ""

$(C_OBJS) : $(OBJ_DIR)/%.o: %.c
	$(CC) $(CC_FLAGS) \
	$(INPUTS) \
	$(C_INCLUDES) \
	-c $< -o $@
	@echo ""
