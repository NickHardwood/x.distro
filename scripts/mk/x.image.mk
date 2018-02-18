### SHELL ######################################################################



# Replace Debian Almquist Shell with Bash

ifeq ($(realpath $(SHELL)),/bin/dash)

SHELL   		:= /bin/bash

endif



# Exit immediately if a command exits with a non-zero exit status

# TODO: .SHELLFLAGS does not exists on obsoleted macOS X-Code make

# .SHELLFLAGS		= -ec

SHELL			+= -e