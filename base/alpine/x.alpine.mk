### BASE_IMAGE #################################################################


BASE_IMAGE_NAME		?= alpine

BASE_IMAGE_TAG		?= $(BASE_IMAGE_OS_VERSION)



BASE_IMAGE_OS_NAME	?= Alpine Linux

BASE_IMAGE_OS_URL	?= https://alpinelinux.org


### MK_DOCKER_IMAGE #############################################################

include $(PROJECT_DIR)/x.version.mk

#################################################################################