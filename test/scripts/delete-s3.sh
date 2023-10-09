if [ "$ENVIRONMENT" == "local" ]
then
    aws() {
        /usr/local/bin/aws --endpoint-url=$LOCAL_AWS_ENDPOINT "$@"
    }
fi

aws s3api delete-object --bucket $BUCKET --key $OBJECT_KEY --region $AWS_REGION
aws s3api delete-bucket --bucket $BUCKET --region $AWS_REGION