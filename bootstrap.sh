#!/bin/bash

set -euo pipefail

# Process one event at a time
while true
do
    # Get an event
    HEADERS="$(mktemp)"
    EVENT_DATA=$(curl -sS -LD "$HEADERS" -X GET "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next")
    REQUEST_ID=$(grep -Fi Lambda-Runtime-Aws-Request-Id "$HEADERS" | tr -d '[:space:]' | cut -d: -f2)
    # Configure AWS and Google Cloud settings
    export AWS_CONFIG_FILE=${LAMBDA_TASK_ROOT}/config
    export AWS_SHARED_CREDENTIALS_FILE=${LAMBDA_TASK_ROOT}/credentials

    # Configure cbt
    echo "project = $GOOGLE_CLOUD_PROJECT" > ~/.cbtrc
    echo "instance = $BIGTABLE_INSTANCE_ID" >> ~/.cbtrc

    # Process the event
    aws s3 cp s3://20241218-hmllc-aws-data/test.csv /tmp/
    gcloud auth activate-service-account --key-file=${LAMBDA_TASK_ROOT}/${GOOGLE_APPLICATION_CREDENTIALS}
    cbt import topic_record /tmp/test.csv --workers=10 --timestamp=0 --batch-size=99999
    # Delete the s3 file
    # aws s3 rm s3://20241218-hmllc-aws-data/test.csv

    # Send the response
    RESPONSE="Data import completed successfully"

    # Send the response
    curl -X POST "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/$REQUEST_ID/response" -d "$RESPONSE"
done