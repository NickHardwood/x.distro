### BASE_IMAGE #################################################################



BASE_IMAGE_NAME		?= arch

BASE_IMAGE_TAG		?= $(BASE_IMAGE_OS_VERSION)



BASE_IMAGE_OS_NAME	?= Arch Linux

BASE_IMAGE_OS_URL	?= https://archlinux.org



### BUILD #######################################################################


BUILD_VARS		+= 	SU_EXEC_VERSION \
					TINI_VERSION

### MK_DOCKER_IMAGE #############################################################

include $(PROJECT_DIR)/x.version.mk

#################################################################################