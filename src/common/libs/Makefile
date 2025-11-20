include $(PROJECT)/misc/config.mk

C_SRCS := $(shell find $(LIBS_DIR) -name "*.c" -type f)

C_OBJS   :=$(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(C_SRCS)))

LIB_INCLUDE_DIRS := $(shell find $(LIBS_DIR) -mindepth 1 -type d)
LIB_INCLUDES := $(foreach dir,$(LIB_INCLUDE_DIRS),-I $(dir))

# Generate vpath for all lib subdirectories
$(foreach dir,$(LIB_INCLUDE_DIRS),$(eval vpath %.c $(dir)))

.PHONY: libs

libs: $(C_OBJS)
	@echo "--- Libs Build Complete ---"
	@echo ""

$(C_OBJS) : $(OBJ_DIR)/%.o: %.c
	$(CC) $(CC_FLAGS) \
	$(INPUTS) \
	$(LIB_INCLUDES) \
	-c $< -o $@
	@echo ""