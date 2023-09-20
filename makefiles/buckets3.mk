
migrate:
	@ aws s3 cp ${CURDIR}/${APP_DIR} s3://${BUCKET_NAME} --recursive