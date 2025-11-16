ASM_SRC    :=start.S
ASM_FORMAT :=-f bin
INCLUDES   :=-I ../firmware/

boot16:
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) $(INPUTS) $(INCLUDES) $(ASM_SRC) -o $(BOOT16)
# 	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) $(INPUTS) $(INCLUDES) -E $(ASM_SRC) > start_debug.S

	@echo -n "Boot16 size in bytes: " >> $(STATS_FILE)
	@wc -c < $(BOOT16) >> $(STATS_FILE)
	@echo ""
	@echo """--- Boot16 Build Complete ---"
	@echo ""
