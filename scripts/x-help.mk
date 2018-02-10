### MAKE_TARGETS ###############################################################
x-help:
	@echo '$(PROJECT) v$(VERSION)'
	@echo '$(COPYRIGHT)'
	@echo ''
	@echo "    Listing your Detected Platform"
	@echo "---------------------------------------"
	@echo '      Kernel Name: ${UNAME_S}'
	@echo '   Kernel Version: ${UNAME_R}'
	@echo '   Kernel Release: ${UNAME_V}'
	@echo ' Machine Hardware: ${UNAME_M}'
	@echo ' Operating System: ${UNAME_O}'
	@echo '   Processor Type: ${UNAME_P}'
	@echo ''
	@echo '  Usage:'
	@echo '    make <target>'
	@echo ''
	@echo '  Targets:'
	@echo ''
	@echo '    all            : processes all project targets "except clean and install"'
	@echo '    clean          : cleans the project tree of build ^(intermediate^) files'
	@echo '    destroy        : destroys all project artifacts and restores source tree back to orginal state'
	@echo '    configure      : downloads and configure the projects ^(binary^) files for extraction'
	@echo '    build          : extracts and layouts project builds results into "builds\" directory'
	@echo '    help           : shows this information and displays usage'
	@echo '    install        : installs the build results into "user defined path" in a non-versioned manner'
	@echo '    fetch          : fetches extensions for ide from internet installs into portable profile'
	@echo '    package        : packages builds for distribution into ".\filename.7z\"'
	@echo '    source         : bootstraps source compilation ".\source\<project>\" for build process'
	@echo ''

################################################################################