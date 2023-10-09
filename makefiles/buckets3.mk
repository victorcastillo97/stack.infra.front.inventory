
STACK_DIR			= ./cloudformation/templates

# Comandos relacionados con la creación de un bucket S3 para templates stacks

create.bucket.stacks: ### Crea un bucket S3 para almacenar recursos relacionados con la infraestructura.
	@ aws s3api create-bucket \
	--bucket ${BUCKET_INFRA} \
	--create-bucket-configuration LocationConstraint=${BUCKET_INFRA_REGION}

stack.migrate.bucket: ### Copia archivos desde el directorio local al bucket S3 de infraestructura.
	@ aws s3 cp ${STACK_DIR} s3://${BUCKET_INFRA_STACK_PATH} --recursive 