
STACK_DIR			= ./cloudformation/templates
FILE_TEMPLATE		= ./cloudformation/stacks.yaml

NAME_STACK			= ${PROJECT_NAME}
BUCKET_STACK_PATH	= ${BUCKET_INFRA}/cloudformation/${OWNER}/${ENV}/${PROJECT_NAME}

DOMAIN_NAME			= victordevelop.com
CACHE_POLICE_NAME	= Managed-CachingOptimized

stack.migrate.s3:
	@ aws s3 cp ${STACK_DIR} s3://${BUCKET_STACK_PATH} --recursive

create.stack:
	$(eval CACHE_POLICE_ID:= $(shell aws cloudfront list-cache-policies --type managed \
		--query 'CachePolicyList.Items[?CachePolicy.CachePolicyConfig.Name==`${CACHE_POLICE_NAME}`].CachePolicy.Id' \
		--output text))

	$(eval HOSTED_ZONE_ID := $(subst /hostedzone/,,$(shell aws route53 list-hosted-zones-by-name \
		--dns-name $${DOMAIN_NAME} --query 'HostedZones[0].Id' --output text)))
		
	@ aws cloudformation create-stack --stack-name $(NAME_STACK) \
	--template-body file://$(FILE_TEMPLATE) \
	--parameters \
		ParameterKey=BucketS3Name,ParameterValue=$(BUCKET_NAME) \
		ParameterKey=BucketS3PathStack,ParameterValue=$(BUCKET_STACK_PATH) \
		ParameterKey=CloudFrontCachePolicyId,ParameterValue=${CACHE_POLICE_ID} \
		ParameterKey=HostedZoneId,ParameterValue=${HOSTED_ZONE_ID} \
		ParameterKey=HostedZoneId,ParameterValue=${DOMAIN_NAME}
	
	@ aws cloudformation wait stack-create-complete  \
	--stack-name $(NAME_STACK)

delete:
	@ aws cloudformation delete-stack --stack-name $(NAME_STACK)

	@ aws cloudformation wait stack-delete-complete  \
	--stack-name $(NAME_STACK)



