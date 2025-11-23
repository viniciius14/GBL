include $(PROJECT)/misc/config.mk

C_SRCS = main.c \
	logo.c \
	vga.c

C_INCLUDE_DIRS = $(COMMON_DIR)/libs/io \
	$(DRIVERS_DIR)/video \
	$(COMMON_DIR)/logo

C_INCLUDES   :=$(foreach dir,$(C_INCLUDE_DIRS),-I $(dir))

$(foreach dir,$(C_INCLUDE_DIRS),$(eval vpath %.c $(dir)))

C_OBJS   :=$(patsubst %.c,$(OBJ_DIR_COMMON)/%.o,$(notdir $(C_SRCS)))

.PHONY: common libs

common: libs $(C_OBJS)

libs:
ifeq ($(ARCH_BITS), BITS32)
	$(MAKE) -C $(COMMON_DIR)/libs libs32
else
	$(MAKE) -C $(COMMON_DIR)/libs libs64
endif

$(OBJ_DIR_COMMON)/%.o: %.c
	$(CC) $(CC_FLAGS) $(CC_FORMAT) \
	$(USER_INPUTS) \
	$(C_INCLUDES) \
	-c $< -o $@
	@echo ""

