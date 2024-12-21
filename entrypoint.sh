#!/bin/bash
export AWS_CONFIG_FILE=/config
export AWS_SHARED_CREDENTIALS_FILE=/credentials
echo project = $GOOGLE_CLOUD_PROJECT >> ~/.cbtrc && echo instance = $BIGTABLE_INSTANCE_ID >> ~/.cbtrc

cd /tmp
aws s3 cp s3://20241218-hmllc-aws-data/test.csv .

gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

# Execute the cbt command
cbt import topic_record /tmp/test.csv --workers=10 --timestamp=0 --batch-size=99999

# Delete the s3 file
aws s3 rm s3://20241218-hmllc-aws-data/test.csv
exec "$@"