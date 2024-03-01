#!/bin/bash

echo "### 10_readsecrets.sh ####"
TOKEN=$(curl --silent -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
SECRETS_REGION=$(curl --silent -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)

APP_PROJECT=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_PROJECT)
APP_ENV_GROUP=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_ENV_GROUP)
APP_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_NAME)
APP_SERVICE=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_SERVICE)
APP_ENVIRONMENT=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_ENVIRONMENT)

SECRETS_ROOT="${APP_PROJECT}-${APP_ENV_GROUP}/${APP_NAME}/${APP_SERVICE}"

fetch_secret() {
	SECRET=$1
	REQUIRED=$2
	WRITE_TO=$3

	echo "---------------------------------------------"
	echo Searching for secret: $SECRET
	FOUND=$(aws --region $SECRETS_REGION secretsmanager get-secret-value --output text --query Name --secret-id $SECRET | tr -d '\n')
    
    echo Found secret: $FOUND
	if [[ "X$FOUND" == "X$SECRET" ]]; then
		echo Writing secret $SECRET to $WRITE_TO
		aws --region $SECRETS_REGION secretsmanager get-secret-value --output text --query SecretString  --secret-id $SECRET > $WRITE_TO
	elif [[ "$REQUIRED" == "true" ]]; then
		echo Secret was not found and is required. Exiting
		exit 1
	else
		echo Secret was not found, writing empty file
		echo "" > $WRITE_TO
	fi

}

fetch_secret ${SECRETS_ROOT}/default.env false .env.app
fetch_secret ${SECRETS_ROOT}/${APP_ENVIRONMENT}.env false .env.app.$(/opt/elasticbeanstalk/bin/get-config environment -k APP_ENVIRONMENT)
fetch_secret ${SECRETS_ROOT}/default.config false application.yaml
fetch_secret ${SECRETS_ROOT}/${APP_ENVIRONMENT}.config false application-$(/opt/elasticbeanstalk/bin/get-config environment -k APP_ENVIRONMENT).yaml

