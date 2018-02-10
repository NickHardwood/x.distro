### DEFAULT ####################################################################

# the default target of this Makefile is...
.DEFAULT_GOAL := help

### PROJECT ####################################################################

PROJECT			:= X.Distro
VERSION			:= $(shell cat .semver)
COPYRIGHT		:= $(shell cat .copyright)
BUILD_NAME		:= $(shell echo $(PROJECT) | tr A-Z a-z)

### SHELL ######################################################################

# setting top-level {root} project directory
TOP=${shell pwd}

# Replace Debian Almquist Shell with Bash
ifeq ($(realpath $(SHELL)),/bin/dash)
SHELL   		:= /bin/bash
endif

# Exit immediately if a command exits with a non-zero exit status
# TODO: .SHELLFLAGS does not exists on obsoleted macOS X-Code make
# .SHELLFLAGS		= -ec
SHELL			+= -e

# detect OS for use in cross platform builds
UNAME_S =$(shell uname -s)
UNAME_M =$(shell uname -m)
UNAME_O =$(shell uname -o)
UNAME_R =$(shell uname -r)
UNAME_P =$(shell uname -p)
UNAME_V =$(shell uname -v)

### COMPILER ###################################################################

CC			:= x86_64-w64-mingw32-gcc
CRES		:= x86_64-w64-mingw32-windres
CFLAGS		:= 
INC			:= -I include

COMPILE		:= $(CC) $(CFLAGS) $(INC)
SRCEXT		:= c
HEADEXT		:= h

### FILESYSTEM #################################################################

# set directory structure of source distribution
BASEDIR		:= base
BINDIR		:= bin
BUILDDIR	:= build
CONFIGDIR	:= config
DOCSDIR		:= doc
INCDIR		:= include
SCRIPTDIR	:= scripts
SRCDIR		:= src
TESTDIR 	:= test

# set directory structure of utility directories
RESDIR		:= resources

# set directory structure of hidden directories
CIDIR		:= .ci
HUBDIR		:= .github
LABDIR		:= .gitlab

# set directory structure of source directories
BASE		:= $(BASEDIR)
SOURCES 	:= $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
TESTS		:= $(shell find $(TESTDIR) -type f -name *.$(SRCEXT))

### MAKE_TARGETS ###############################################################

# shows this information and displays usage
help: x-help
  include $(SCRIPTDIR)/x-help.mk

all:

build: $(BUILD_NAME)

$(BUILD_NAME):
	$(info Building $(PROJECT) v$(VERSION)...)
	@mkdir $(BINDIR) $(BUILDDIR) $(BUILDDIR)/$(RESDIR)/
	@$(COMPILE) $(SOURCES) -o $(BINDIR)/launcher.exe
	@find  $(BASE)/* -maxdepth 1 -type d -printf '%f\n' > $(BUILDDIR)/resl.txt
	@xargs -a $(BUILDDIR)/resl.txt -I{} $(CRES) $(BASE)/{}/res.rc -o $(BUILDDIR)/$(RESDIR)/{}.o
	@xargs -a $(BUILDDIR)/resl.txt -I{} $(COMPILE) $(SOURCES) $(BUILDDIR)/$(RESDIR)/{}.o -o $(BINDIR)/{}.exe
	
	@echo "Creating zip file of $(PROJECT) v$(VERSION) executables..."
	@cd $(BINDIR)/ && zip ../$(BUILDDIR)/launchers.zip *
	@cd ..
	@echo "Zip file creation for $(PROJECT) v$(VERSION) executables completed..."
	@echo "Building of $(PROJECT) v$(VERSION) completed..."

clean:
	$(info Cleaning of $(PROJECT) v$(VERSION)...)
	@rm -rf $(BUILDDIR) $(BINDIR)
	@echo "Cleaning of $(PROJECT) v$(VERSION) completed..."

setup:

run_sublime:

run_vscode:

run_test:

################################################################################