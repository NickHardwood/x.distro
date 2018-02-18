### DEFAULT ####################################################################

# the default target of this Makefile is...
.DEFAULT_GOAL := help

### PROJECT ####################################################################

PROJECT			:= $(shell cat .dist.project)
VERSION			:= $(shell cat .dist.semver)
COPYRIGHT		:= $(shell cat .dist.copyright)
BUILD_NAME		:= $(shell echo $(PROJECT) | tr A-Z a-z)

### SHELL ######################################################################

# setting top-level {root} project directory
TOP=${shell pwd}

# Replace Debian Almquist Shell with Bash
ifeq ($(realpath $(SHELL)),/bin/dash)
SHELL   	:= /bin/bash
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
DISTDIR		:= dist
DOCSDIR		:= doc
INCDIR		:= include
SCRIPTDIR	:= scripts
SRCDIR		:= src
TESTDIR 	:= test

# set directory structure of utility directories
RESDIR		:= resources
MKDIR		:= mk

# set directory structure of hidden directories
CIDIR		:= .ci
HUBDIR		:= .github
LABDIR		:= .gitlab

# set directory structure of source directories
BASE		:= $(BASEDIR)
DIST		:= $(DISTDIR)
SOURCES 	:= $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
TESTS		:= $(shell find $(TESTDIR) -type f -name *.$(SRCEXT))


### BASE_DOCKER_VARIANTS #######################################################

# base docker image variants

X_VARIANTS 	+= alpine \
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

X_VARIANT_TARGETS 	+= build \
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
  include $(SCRIPTDIR)/$(MKDIR)/x.help.mk

# Build all images and run all tests
.PHONY: all

all: ci

# Subdir targets
.PHONY: $(X_VARIANT_TARGETS)
$(X_VARIANT_TARGETS):
	@for X_VARIANT in $(X_VARIANTS); do \
		cd $(CURDIR)/$(BASE)/$${X_VARIANT}; \
		$(MAKE) $@; \
	done

run_vscode:
	$(info Running VSCode for $(PROJECT) v$(VERSION)...)
	@docker run --rm -e DISPLAY=10.0.75.1:0.0 -v /d/Projects:/code jess/vscode

################################################################################