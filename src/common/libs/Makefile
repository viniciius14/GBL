include $(PROJECT)/misc/config.mk

C_SRCS := $(shell find $(LIBS_DIR) -name "*.c" -type f)

C_OBJS32   :=$(patsubst %.c,$(OBJ_DIR32)/%.o,$(notdir $(C_SRCS)))
C_OBJS64   :=$(patsubst %.c,$(OBJ_DIR64)/%.o,$(notdir $(C_SRCS)))

LIB_INCLUDE_DIRS := $(shell find $(LIBS_DIR) -mindepth 1 -type d)
LIB_INCLUDES := $(foreach dir,$(LIB_INCLUDE_DIRS),-I $(dir))

# Generate vpath for all lib subdirectories
$(foreach dir,$(LIB_INCLUDE_DIRS),$(eval vpath %.c $(dir)))

.PHONY: libs32 libs64

libs32: $(C_OBJS32)
	@echo "--- Libs 32 Build Complete ---"
	@echo ""

$(OBJ_DIR32)/%.o: %.c
	$(CC) $(CC_FLAGS) \
	$(USER_INPUTS) \
	$(LIB_INCLUDES) \
	-c $< -o $@
	@echo ""

libs64: $(C_OBJS64)
	@echo "--- Libs 64 Build Complete ---"
	@echo ""

$(OBJ_DIR64)/%.o: %.c
	$(CC64) $(CC_FLAGS) \
	$(USER_INPUTS) \
	$(LIB_INCLUDES) \
	-c $< -o $@
	@echo ""