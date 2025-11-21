include $(PROJECT)/misc/config.mk

ifeq ($(ARCH_BITS), BITS32)
CURR_OBJ_DIR := $(OBJ_DIR32)
else ifeq ($(ARCH_BITS), BITS64)
CURR_OBJ_DIR := $(OBJ_DIR64)
endif

C_SRCS := $(shell find $(LIBS_DIR) -name "*.c" -type f)

C_OBJS   :=$(patsubst %.c,$(CURR_OBJ_DIR)/%.o,$(notdir $(C_SRCS)))

LIB_INCLUDE_DIRS := $(shell find $(LIBS_DIR) -mindepth 1 -type d)
LIB_INCLUDES := $(foreach dir,$(LIB_INCLUDE_DIRS),-I $(dir))

# Generate vpath for all lib subdirectories
$(foreach dir,$(LIB_INCLUDE_DIRS),$(eval vpath %.c $(dir)))

.PHONY: libs

libs: $(C_OBJS)
	@echo "--- Libs Build Complete ---"
	@echo ""

$(C_OBJS) : $(CURR_OBJ_DIR)/%.o: %.c
	$(CC) $(CC_FLAGS) \
	$(USER_INPUTS) \
	$(LIB_INCLUDES) \
	-c $< -o $@
	@echo ""