include $(PROJECT)/misc/config.mk

C_SRCS = main.c \
	logo.c \
	vga.c

C_INCLUDE_DIRS = $(COMMON_DIR)/libs/io \
	$(DRIVERS_DIR)/video \
	$(COMMON_DIR)/logo

C_INCLUDES   :=$(foreach dir,$(C_INCLUDE_DIRS),-I $(dir))

$(foreach dir,$(C_INCLUDE_DIRS),$(eval vpath %.c $(dir)))

ifeq ($(ARCH_BITS), BITS32)
CURR_CC := $(CC)
CURR_LD_FORMAT := $(LD_FORMAT)
else
CURR_CC := $(CC64)
CURR_LD_FORMAT := $(LD_FORMAT64)
endif

C_OBJS   :=$(patsubst %.c,$(OBJ_DIR_COMMON)/%.o,$(notdir $(C_SRCS)))

.PHONY: all

all: $(C_OBJS)
	$(LD) -r $(CURR_LD_FORMAT) $(OBJ_DIR_COMMON)/*.o -o $(OBJ_DIR_COMMON)/common.o


$(C_OBJS): $(OBJ_DIR_COMMON)/%.o: %.c
	$(CURR_CC) $(CC_FLAGS) \
	$(USER_INPUTS) \
	$(C_INCLUDES) \
	-c $< -o $@
	@echo ""

