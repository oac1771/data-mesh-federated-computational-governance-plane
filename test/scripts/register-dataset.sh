envsubst '${S3_ENDPOINT},${BUCKET},${OBJECT_KEY},${TEST_APP_NAME},${FYBRIK_WORKLOAD_NS},${AWS_REGION}' \
    < test/templates/register-dataset-payload.json.TEMPLATE > \
    register-dataset-payload.json

cat register-dataset-payload.json

export RESPONSE=$(curl -X POST http://openmetadata-connector.$FYBRIK_NS:8080/createAsset -d "@register-dataset-payload.json")

if echo $RESPONSE | jq -e '.assetID' >> /dev/null; then
    echo $RESPONSE
elif echo $RESPONSE | grep -q "asset already exists" ; then
    echo "Asset already exists..."
    export ASSET_ID=$(echo "openmetadata-s3.default.$BUCKET.\\"\"$OBJECT_KEY\\"\"")
    echo "{\"assetID\":\"$ASSET_ID\"}"
else
    echo Could not create asset...
    echo $RESPONSE
    exit 1
fi
