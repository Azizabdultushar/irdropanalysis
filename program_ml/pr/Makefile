###############################
## Default target            ##
###############################
run: generate_parameter clean-used repeat


######################################
## Parameter file generation target ##
######################################
clean_parameter:
		bash ./scripts/automation_script/clean.sh

generation:
		bash ./scripts/automation_script/setup_generator_update

###########################################
##clean the used parameter script/inputs ##
###########################################
# Target to clean used files
.PHONY: clean-used-parameter
clean-used-parameter:
	@echo "Cleaning used files: $(USED_FILES)..."
	@rm -f $(USED_FILES) || { echo "Failed to remove $(USED_FILES)."; exit 1; }
	@touch $(USED_FILES)
	@echo "$(USED_FILES) has been reset."
################################################
## physical design and static IRDrop analysis ##
################################################
SHELL := /bin/bash
SETUP_DIR := ./scripts/automation_script/generated_tcl_parameter
USED_FILES := used_files.txt
SETUP_FILE := $(shell comm -23 <(ls $(SETUP_DIR)/setup*.tcl | sort) <(cat $(USED_FILES) 2>/dev/null | sort) | shuf -n 1)
MAIN_TCL_SCRIPT := ./scripts/innovus_main1.tcl
MAIN_TCL_SCRIPT2 := ./scripts/voltus_main1.tcl
TEMP_TCL_SCRIPT := ./scripts/temp_script.tcl
TEMP_TCL_SCRIPT2 := ./scripts/temp_script2.tcl
$(USED_FILES):
	touch $(USED_FILES)
# Place and Route Target
placeandroute: $(USED_FILES)
	@if [ -z "$(SETUP_FILE)" ]; then \
		echo "All setup files have been used!"; \
		exit 1; \
	else \
		echo "Using setup file: $(SETUP_FILE)"; \
		echo $(SETUP_FILE) >> $(USED_FILES); \
		echo "Creating temporary TCL script to source both setup and main scripts..."; \
		echo "#Sourcing setup file: $(SETUP_FILE)" > $(TEMP_TCL_SCRIPT); \
		echo "source $(SETUP_FILE)" >> $(TEMP_TCL_SCRIPT); \
		echo "#Sourcing main TCL script: $(MAIN_TCL_SCRIPT)" >> $(TEMP_TCL_SCRIPT); \
		echo "source $(MAIN_TCL_SCRIPT)" >> $(TEMP_TCL_SCRIPT); \
		innovus -nowin -overwrite -init $(TEMP_TCL_SCRIPT) -log logs/innovus_phrase1.log -cmd logs/innovus_phrase1.cmd; \
		rm $(TEMP_TCL_SCRIPT); \
		echo "Creating temporary TCL script to source both setup and main scripts..."; \
		echo "#Sourcing setup file: $(SETUP_FILE)" > $(TEMP_TCL_SCRIPT2); \
		echo "source $(SETUP_FILE)" >> $(TEMP_TCL_SCRIPT2); \
		echo "#Sourcing main TCL script: $(MAIN_TCL_SCRIPT2)" >> $(TEMP_TCL_SCRIPT2); \
		echo "source $(MAIN_TCL_SCRIPT2)" >> $(TEMP_TCL_SCRIPT2); \
		voltus -nowin -overwrite -init $(TEMP_TCL_SCRIPT2) -log logs/voltus_phrase1.log -cmd logs/voltus_phrase1.cmd; \
		rm $(TEMP_TCL_SCRIPT2); \
	fi


####################################################################################
## repeatation of physical design and Static IRDrop analysis for all parameter file#
####################################################################################
.PHONY: repeat
repeat:
	@while true; do \
		$(MAKE) placeandroute; \
		echo "Waiting a few moments before the next iteration..."; \
		sleep 5; \
	done

###################################################################################
###                                  END                                        ###
###################################################################################
