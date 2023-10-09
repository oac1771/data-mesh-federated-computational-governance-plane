export ACCESS_TOKEN=$(curl -X POST $OPENMETADATA_ENDPOINT/v1/users/login -H  "accept: application/json" \
            -H  "Content-Type: application/json" \
            -d "{\"email\":\"admin\",\"password\":\"admin\"}" | jq '.accessToken' | tr -d '"')

export SCHEMA_NAME=$(echo $CATALOGED_ASSET | cut -d '.' -f 1-3)
export DATABASE_NAME=$(echo $CATALOGED_ASSET | cut -d '.' -f 1-2)
export DATABASE_SERVICE_NAME=$(echo $CATALOGED_ASSET | cut -d '.' -f 1)


# delete table by name
curl -X DELETE $OPENMETADATA_ENDPOINT/v1/tables/name/$CATALOGED_ASSET?hardDelete=true \
    -H "accept: */*" -H "Authorization: Bearer $ACCESS_TOKEN"

# get schema by id
export SCHEMA_ID=$(curl $OPENMETADATA_ENDPOINT/v1/databaseSchemas/name/$SCHEMA_NAME \
    -H "accept: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" | jq '.id' | tr -d '"')
# delete schema by id
curl -X DELETE $OPENMETADATA_ENDPOINT/v1/databaseSchemas/$SCHEMA_ID?hardDelete=true \
    -H  "accept: */*" -H "Authorization: Bearer $ACCESS_TOKEN"

# get database by id
export DATABASE_ID=$(curl $OPENMETADATA_ENDPOINT/v1/databases/name/$DATABASE_NAME \
    -H "accept: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" | jq '.id' | tr -d '"')
# delete schema by id
curl -X DELETE $OPENMETADATA_ENDPOINT/v1/databases/$DATABASE_ID?hardDelete=true \
    -H  "accept: */*" -H "Authorization: Bearer $ACCESS_TOKEN"


# cant delete full db service because is not empty

# # get database service
# export DATABASE_SERVICE_ID=$(curl $OPENMETADATA_ENDPOINT/v1/services/databaseServices/name/$DATABASE_SERVICE_NAME \
#     -H "accept: application/json" -H "Authorization: Bearer $ACCESS_TOKEN" | jq '.id' | tr -d '"')
# # delete database service by id
# curl -X DELETE $OPENMETADATA_ENDPOINT/v1/services/databaseServices/$DATABASE_SERVICE_ID?hardDelete=true \
#     -H "accept: */*" -H "Authorization: Bearer $ACCESS_TOKEN"