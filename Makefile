### DEFAULT ####################################################################

# the default target of this Makefile is...
.DEFAULT_GOAL := help

### SHELL ######################################################################

# Replace Debian Almquist Shell with Bash
ifeq ($(realpath $(SHELL)),/bin/dash)
SHELL   	:= /bin/bash
endif

# Exit immediately if a command exits with a non-zero exit status
# TODO: .SHELLFLAGS does not exists on obsoleted macOS X-Code make
# .SHELLFLAGS		= -ec
SHELL			+= -e

# import base properties
include ./scripts/mk/x.properties.mk

### BASE_DOCKER_VARIANTS #######################################################

# base docker image variants

BASE_VARIANTS 	+= alpine \
		arch \
		busybox \
		centos \
		clear \
		crux \
		debian \
		euleros \
		fedora \
		gentoo \
		kali \
		mageia \
		manjaro \
		minideb \
		opensuse \
		oracle \
		sabayon \
		turnkey \
		ubuntu


# Make targets propagated to all Docker image variants

BASE_VARIANT_TARGETS 	+= build \
				rebuild \
				ci \
				clean \
				docker-pull \
				docker-pull-baseimage \
				docker-pull-dependencies \
				docker-pull-image \
				docker-pull-testimage \
				docker-push \
				docker-load-image \
				docker-save-image

### MAKE_TARGETS ###############################################################

# shows this information and displays usage
help: x-help
  include $(SCRIPT_DIR)/$(MK_DIR)/x.help.mk

# Build all images and run all tests
.PHONY: all

all: ci

# Subdir targets
.PHONY: $(BASE_VARIANT_TARGETS)
$(BASE_VARIANT_TARGETS):
	@for BASE_VARIANT in $(BASE_VARIANTS); do \
		cd $(CURRENT_DIR)/$(BASE_DIR)/$${BASE_VARIANT}; \
		$(MAKE) $@; \
	done

.PHONY: create
create:
	@if [ -z "$(NAME)" ]; then \
		$(ECHO) "ERROR: Docker project NAME must be defined"; \
		$(ECHO); \
		$(MAKE) help; \
		$(ECHO); \
		exit 1; \
	fi
	@if [ -e ../$(NAME) -a "$(OVERWRITE)" != "yes" ]; then \
		$(ECHO) "ERROR: The directory $(DOCKER_DIR)/$(NAME) exist"; \
		$(ECHO); \
		$(MAKE) help; \
		$(ECHO); \
		exit 1; \
	fi
	@mkdir -p $(DOCKER_DIR)
	@mkdir -p $(DOCKER_DIR)/$(NAME)
	cp -afv $(CONFIG_DIR)/sample/. $(DOCKER_DIR)/$(NAME)

launcher: $(BUILD_NAME)

$(BUILD_NAME):
	$(info Building $(PROJECT) v$(VERSION)...)
	@mkdir $(BUILD_DIR) $(BUILD_DIR)/$(RES_DIR)/ $(BUILD_DIR)/$(DIST_DIR) $(BUILD_DIR)/$(BIN_DIR) $(WSL_DIR)
	@$(COMPILE) $(SOURCES) -o $(BUILD_DIR)/$(BIN_DIR)/launcher.exe
	@find  $(BASE_DIR)/* -maxdepth 0 -type d -printf '%f\n' > $(BUILD_DIR)/resl.txt
	@xargs -a $(BUILD_DIR)/resl.txt -I{} $(CRES) $(BASE_DIR)/{}/res.rc -o $(BUILD_DIR)/$(RES_DIR)/{}.o
	@xargs -a $(BUILD_DIR)/resl.txt -I{} $(COMPILE) $(SOURCES) $(BUILD_DIR)/$(RES_DIR)/{}.o -o $(BUILD_DIR)/$(BIN_DIR)/{}.exe
	@xargs -a $(BUILD_DIR)/resl.txt -I{} mkdir $(WSL_DIR)/{}
	@xargs -a $(BUILD_DIR)/resl.txt -I{} cp $(BUILD_DIR)/$(BIN_DIR)/{}.exe $(WSL_DIR)/{}/{}.exe
	
	@cd $(BUILD_DIR)/$(BIN_DIR)/ && zip ../launchers.zip *
	@cd ../../

distclean:
	$(info Cleaning of $(PROJECT) v$(VERSION)...)
	@rm -rf $(BUILD_DIR)
	@rm -rf $(DOCKER_DIR)
	@rm -rf $(WSL_DIR)

mostlyclean:
	$(info Cleaning of $(PROJECT) v$(VERSION)...)
	@rm -rf $(BUILD_DIR)

run_vscode:
	$(info Running VSCode for $(PROJECT) v$(VERSION)...)
	@docker run --rm -e DISPLAY=10.0.75.1:0.0 -v /d/Projects:/code jess/vscode

################################################################################