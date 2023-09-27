
STACK_DIR			= ./cloudformation/templates
FILE_TEMPLATE		= ./cloudformation/stacks.yaml

NAME_STACK			= ${PROJECT_NAME}
BUCKET_STACK_PATH	= ${BUCKET_INFRA}/cloudformation/${OWNER}/${ENV}/${PROJECT_NAME}


stack.migrate.s3:
	@ aws s3 cp ${STACK_DIR} s3://${BUCKET_STACK_PATH} --recursive


create:
	@ aws cloudformation create-stack --stack-name $(NAME_STACK) \
	--template-body file://$(FILE_TEMPLATE) \
	--parameters \
		ParameterKey=BucketS3Name,ParameterValue=$(BUCKET_NAME) \
		ParameterKey=BucketS3PathStack,ParameterValue=$(BUCKET_STACK_PATH) \
		ParameterKey=CloudFrontCachePolicyId,ParameterValue='658327ea-f89d-4fab-a63d-7e88639e58f6'

	@ aws cloudformation wait stack-create-complete  \
	--stack-name $(NAME_STACK)

delete:
	@ aws cloudformation delete-stack --stack-name $(NAME_STACK)

	@ aws cloudformation wait stack-delete-complete  \
	--stack-name $(NAME_STACK)

get.id.cache.policy:
	@ aws cloudfront list-cache-policies --type managed \
	--query 'CachePolicyList.Items[?CachePolicy.CachePolicyConfig.Name==`Managed-CachingOptimized`].CachePolicy.Id' \
	--output text
