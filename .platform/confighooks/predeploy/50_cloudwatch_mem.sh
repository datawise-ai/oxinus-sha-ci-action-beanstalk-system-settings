#!/bin/bash

APP_PROJECT=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_PROJECT)
APP_ENV_GROUP=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_ENV_GROUP)
APP_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_NAME)
APP_SERVICE=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_SERVICE)
APP_ENVIRONMENT=$(/opt/elasticbeanstalk/bin/get-config environment -k APP_ENVIRONMENT)

cat <<EOF > /tmp/mem.json
{
   "metrics":{
      "append_dimensions" : {
      },
      "metrics_collected":{
         "mem":{
            "measurement":[
               "used_percent"
            ],
            "metrics_collection_interval":30,
             "append_dimensions": {
               "app": "${APP_PROJECT}-${APP_NAME}-${APP_SERVICE}-${APP_ENVIRONMENT}"
            }
         }
      }
   }
}

EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m ec2 -s -c file:/tmp/mem.json
