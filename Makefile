
include makefiles/buckets3.mk

OWNER          	= inventory
TYPE_APP        = web
SERVICE_NAME    = front
ENV             ?= dev
AWS_REGION 		= us-west-2

PROJECT_NAME    = ${OWNER}-${TYPE_APP}-${SERVICE_NAME}-${ENV}

BUCKET_NAME 	= ${OWNER}.${TYPE_APP}.${SERVICE_NAME}.${ENV}.bucket


BUCKET_S3		= dev.
STACK_NAME		= bucketWebsite
TEMPLATE_FILE	= cloudformation/templates/bucketWebsite.yaml

APP_DIR 		= app


create.stack:
	@ aws cloudformation create-stack --stack-name $(STACK_NAME) \
	--template-body file://${CURDIR}/$(TEMPLATE_FILE) \
	--parameters \
		ParameterKey=BucketS3Name,ParameterValue=$(BUCKET_NAME)

	@ aws cloudformation wait stack-create-complete  \
	--stack-name $(STACK_NAME)

delete.stack:
	@ aws cloudformation delete-stack --stack-name $(STACK_NAME)
	@ aws cloudformation wait stack-delete-complete  \
	--stack-name $(STACK_NAME)
