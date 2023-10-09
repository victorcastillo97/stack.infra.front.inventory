.DEFAULT_GOAL := help

include makefiles/buckets3.mk
include makefiles/stack.mk

OWNER          	= inventory
TYPE_APP        = web
SERVICE_NAME    = front
ENV             ?= dev

PROJECT_NAME    		= ${OWNER}-${TYPE_APP}-${SERVICE_NAME}-${ENV}

BUCKET_INFRA_REGION		= us-west-2
BUCKET_INFRA			= infra.stacks.${ENV}.2
BUCKET_INFRA_STACK_PATH	= ${BUCKET_INFRA}/cloudformation/${OWNER}/${ENV}/${PROJECT_NAME}

DOMAIN_NAME			= victordevelop.com


perro: ## Goo
	@ echo "Comandos disponibles: