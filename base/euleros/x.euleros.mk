### BASE_IMAGE #################################################################



BASE_IMAGE_NAME		?= euleros

BASE_IMAGE_TAG		?= $(BASE_IMAGE_OS_VERSION)



BASE_IMAGE_OS_NAME	?= EulerOS

BASE_IMAGE_OS_URL	?= https://developer.huawei.com/ict/en/site-euleros



### BUILD #######################################################################


BUILD_VARS		+= 	SU_EXEC_VERSION \
					TINI_VERSION

### MK_DOCKER_IMAGE #############################################################

include $(PROJECT_DIR)/x.version.mk

#################################################################################