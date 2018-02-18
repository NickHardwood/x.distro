### SYSTEM #####################################################################

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
SRC_EXT		:= c
HEAD_EXT	:= h

### PROJECT ####################################################################

# setting project name from .dist.project file
PROJECT			:= $(shell cat .dist.project)

# setting project version from .dist.version file
VERSION			:= $(shell cat .dist.semver)

# setting project copyright from .dist.copyright file
COPYRIGHT		:= $(shell cat .dist.copyright)

# setting build name from $(PROJECT)
BUILD_NAME		:= $(shell echo $(PROJECT) | tr A-Z a-z)

### FILESYSTEM #################################################################

# setting top-level {root} project directory
TOP=${shell pwd}
CURRENT_DIR	:= $(CURDIR)

# set directory structure of source distribution
BASE_DIR	:= base
BIN_DIR		:= bin
BUILD_DIR	:= build
CONFIG_DIR	:= config
DIST_DIR	:= dist
DOCS_DIR	:= doc
INC_DIR		:= include
SCRIPT_DIR	:= scripts
SRC_DIR		:= src
TEST_DIR 	:= test

# set directory structure of utility directories
RES_DIR		:= resources
MK_DIR		:= mk

# set directory structure of hidden directories
DOCKER_DIR	:= .docker
WSL_DIR		:= .wsl

# set directory structure of source directories
SOURCES 	:= $(shell find $(SRC_DIR) -type f -name *.$(SRC_EXT))
TESTS		:= $(shell find $(TEST_DIR) -type f -name *.$(SRC_EXT))

### COMMANDS ###################################################################

ECHO			= /bin/echo

