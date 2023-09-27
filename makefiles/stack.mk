NAME_STACK		= stackComplete
FILE_TEMPLATE	= cloudformation/stackComplete.yaml

BUCKET_STACK	= infra.stacks.${ENV}
STACK_DIR		= ./cloudformation/templates
STACK_FILE		= ./cloudformation/stacks.yaml

stack.migrate.s3:
	@ aws s3 cp ${STACK_DIR} s3://${BUCKET_STACK} --recursive

create.cdn:
	@ aws cloudformation create-stack --stack-name $(NAME_STACK) \
	--template-body file://${CURDIR}/$(FILE_TEMPLATE)

	@ aws cloudformation wait stack-create-complete  \
	--stack-name $(NAME_STACK)

create:
	@ aws cloudformation create-stack --stack-name $(NAME_STACK) \
	--template-body file://${CURDIR}/$(FILE_TEMPLATE) \
	--parameters \
		ParameterKey=BucketS3Name,ParameterValue=$(BUCKET_NAME)

	@ aws cloudformation wait stack-create-complete  \
	--stack-name $(NAME_STACK)

delete:
	@ aws cloudformation delete-stack --stack-name $(NAME_STACK)

	@ aws cloudformation wait stack-delete-complete  \
	--stack-name $(NAME_STACK)
