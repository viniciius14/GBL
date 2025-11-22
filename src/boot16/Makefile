ASM_SRC    :=start.S
ASM_FORMAT32 :=-f bin
INCLUDES   :=-I ../firmware/

# Since only 1 file, hardcode here
boot16:
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT32) $(USER_INPUTS) $(INCLUDES) start.S -o $(BOOT16)
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT32) $(USER_INPUTS) $(INCLUDES) -E start.S > $(DEBUG_DIR16)/start.S

# Stats
	@echo -n "Boot16 size in bytes: " >> $(STATS_FILE)
	@wc -c < $(BOOT16) >> $(STATS_FILE)
	@echo ""
	@echo """--- Boot16 Build Complete ---"
	@echo ""
