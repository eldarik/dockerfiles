#! /bin/sh

set -e
set -o pipefail

if [ "${S3_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${S3_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${MONGODB_URL}" = "**None**" ]; then
  echo "You need to set the MONGODB_URL environment variable."
  exit 1
fi

if [ "${S3_ENDPOINT}" == "**None**" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

echo "Creating dump..."

mongodump --uri=$MONGODB_URL
tar -czvf dump.tar.gz dump/

echo "Uploading dump to $S3_BUCKET"

cat dump.tar.gz | aws $AWS_ARGS s3 cp - s3://$S3_BUCKET/$S3_PREFIX/mongo_db_${MONGODB_DATABASE}_$(date +"%Y-%m-%dT%H:%M:%SZ").tar.gz || exit 2

echo "mongodb backup uploaded successfully"
