# Comandos relacionados con la creación y eliminación de stacks de CloudFormation

STACK_S3_TEMPLATE		= ./cloudformation/S3.yaml
STACK_S3_NAME			= ${PROJECT_NAME}-buckets3
STACK_S3_FOR_REGION		= us-west-2
BUCKET_WEB_NAME 		= ${OWNER}.${TYPE_APP}.${SERVICE_NAME}.${ENV}.buckets3

STACKS_TEMPLATE			= ./cloudformation/stacks.yaml
STACKS_NAME				= ${PROJECT_NAME}-stacks
STACKS_FOR_REGION		= us-east-1
CACHE_POLICE_CLOUDFRONT	= Managed-CachingOptimized

stack.s3.create: ### Crea un stack de CloudFormation para configurar un bucket S3.
	@ echo 'Creating stack for bucket s3...'
	
	@ aws cloudformation create-stack --stack-name $(STACK_S3_NAME) \
	--template-body file://$(STACK_S3_TEMPLATE) \
	--parameters \
		ParameterKey=BucketS3Name,ParameterValue=$(BUCKET_WEB_NAME) \
		ParameterKey=StackFilesRegion,ParameterValue=$(BUCKET_INFRA_REGION) \
		ParameterKey=StackFilesPathTemplates,ParameterValue=$(BUCKET_INFRA_STACK_PATH) \
		--region ${STACK_S3_FOR_REGION}
	@ aws cloudformation wait stack-create-complete  \
	--stack-name $(STACK_S3_NAME) --region ${STACK_S3_FOR_REGION}

stack.s3.delete: ## Elimina el stack de CloudFormation creado para el bucket S3.
	@ aws cloudformation delete-stack --stack-name $(STACK_S3_NAME) \
	--region ${STACK_S3_FOR_REGION}

	@ aws cloudformation wait stack-delete-complete  \
	--stack-name $(STACK_S3_NAME) --region ${STACK_S3_FOR_REGION}


stacks.create: ## Crea un stack de CloudFormation para CloudFront, certificados SSL y registros DNS en Route 53.
	@ echo 'Getting outputs fron stack S3'
	$(eval RESULT_STACK_S3:= $(shell aws cloudformation describe-stacks \
		--stack-name ${STACK_S3_NAME} --region us-west-2 \
		--query 'Stacks[0].Outputs[?OutputKey==`RegionalDomainName` || OutputKey==`Arn`].OutputValue' \
		--output json ))
	$(eval BUCKET_WEB_REGIONAL_DOMAIN_NAME := $(shell echo ${RESULT_STACK_S3} | jq -r ".[0]"))
	$(eval BUCKET_WEB_ARN := $(shell echo ${RESULT_STACK_S3} | jq -r ".[1]"))

	@ echo 'Getting values CACHE_POLICE_ID, HOSTED_ZONE_ID'
	$(eval CACHE_POLICE_ID:= $(shell aws cloudfront list-cache-policies --type managed \
		--query 'CachePolicyList.Items[?CachePolicy.CachePolicyConfig.Name==`${CACHE_POLICE_NAME}`].CachePolicy.Id' \
		--output text))

	$(eval HOSTED_ZONE_ID := $(subst /hostedzone/,,$(shell aws route53 list-hosted-zones-by-name \
		--dns-name $${DOMAIN_NAME} --query 'HostedZones[0].Id' --output text)))

	@ echo 'Creating stack for clodufront, certificate, route53...'
	@ aws cloudformation create-stack --stack-name $(STACKS_NAME) \
	--template-body file://$(STACKS_TEMPLATE) \
	--parameters \
		ParameterKey=StackFilesRegion,ParameterValue=$(BUCKET_INFRA_REGION) \
		ParameterKey=StackFilesPathTemplates,ParameterValue=$(BUCKET_INFRA_STACK_PATH) \
		ParameterKey=CloudFrontCachePolicyId,ParameterValue=${CACHE_POLICE_ID} \
		ParameterKey=HostedZoneId,ParameterValue=${HOSTED_ZONE_ID} \
		ParameterKey=DomainName,ParameterValue=${DOMAIN_NAME} \
		ParameterKey=BucketWebName,ParameterValue=${BUCKET_WEB_NAME} \
		ParameterKey=BucketWebArn,ParameterValue=${BUCKET_WEB_ARN} \
		ParameterKey=BucketWebRegionalDomainName,ParameterValue=${BUCKET_WEB_REGIONAL_DOMAIN_NAME} \
		--region ${STACKS_FOR_REGION}

	@ echo 'Waiting stack created...'
	@ aws cloudformation wait stack-create-complete  \
	--stack-name $(STACKS_NAME) --region ${STACKS_FOR_REGION}

stacks.delete: ## Elimina el stack de CloudFormation creado para CloudFront, certificados SSL y registros DNS en Route 53.
	@ aws cloudformation delete-stack --stack-name $(STACKS_NAME) \
	--region ${STACKS_FOR_REGION}

	@ aws cloudformation wait stack-delete-complete  \
	--stack-name $(STACKS_NAME) --region ${STACKS_FOR_REGION}
