envsubst '${BUCKET}' \
    < test/templates/s3-bucket-policy.json.TEMPLATE > \
    s3-bucket-policy.json

if [ "$ENVIRONMENT" == "local" ]
then
    aws() {
        /usr/local/bin/aws --endpoint-url=$LOCAL_AWS_ENDPOINT "$@"
    }
fi

if aws s3 ls | grep $BUCKET
then
    echo $BUCKET exists...
else
    aws s3api create-bucket \
        --bucket $BUCKET --region $AWS_REGION \
        --create-bucket-configuration LocationConstraint=$AWS_REGION --no-cli-pager
    aws s3api put-bucket-policy --bucket $BUCKET --policy file://s3-bucket-policy.json
fi

if aws s3 ls $BUCKET | grep $OBJECT_KEY
then
    echo $FILEPATH exists in $BUCKET...
else
    aws s3api put-object --bucket $BUCKET --key $OBJECT_KEY \
        --body $FILEPATH --no-cli-pager
fi