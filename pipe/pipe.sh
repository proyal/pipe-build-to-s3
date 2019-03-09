#!/bin/bash
#
# This pipe executes a command to build a node project, zips it up, and uploads it to s3.
#

source "$(dirname "$0")/common.sh"

#
# Required parameters
#
DIST_PATH=${DIST_PATH:?'DIST_PATH variable missing.'}
AWS_REGION=${AWS_REGION:?'AWS_REGION variable missing.'}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?'AWS_SECRET_ACCESS_KEY variable missing.'}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?'AWS_ACCESS_KEY_ID variable missing.'}
S3_BUCKET=${S3_BUCKET:?'S3_BUCKET variable missing.'}

#
# If S3_DIST_FILENAME is defined, use it, otherwise use a combination of BITBUCKET_REPO_SLUG, BITBUCKET_COMMIT, and TARGET_ENV
#
if [ -z $S3_DIST_FILENAME ]
then
  if [ -z $BITBUCKET_REPO_SLUG ] || [ -z $BITBUCKET_COMMIT ]
  then
    fail "If S3_DIST_FILENAME is not defined, BITBUCKET_REPO_SLUG and BITBUCKET_COMMIT must be defined to create a default."
  fi

  if [ -z $TARGET_ENV ]
  then
    S3_DIST_FILENAME=${BITBUCKET_REPO_SLUG}_${BITBUCKET_COMMIT}.zip
  else
    S3_DIST_FILENAME=${BITBUCKET_REPO_SLUG}_${BITBUCKET_COMMIT}_${TARGET_ENV}.zip
  fi
fi

#
# Default parameters
#
DEBUG=${DEBUG:="false"}
BUILD_COMMAND=${BUILD_COMMAND:='npm run build'}

#
# Echo non-sensitive variables that are about to be used.
#
evs=(DIST_PATH
     BUILD_COMMAND
     AWS_REGION
     S3_BUCKET
     S3_DIST_FILENAME
     BITBUCKET_REPO_SLUG
     BITBUCKET_COMMIT
     TARGET_ENV)

for ev in "${evs[@]}"
do
  echo $ev=\'${!ev}\'
done

#
# Begin the work.
#
run npm ci
run npm run lint
run eval ${BUILD_COMMAND}
run "$(dirname "$0")/create-version-file.sh"
run cd ${DIST_PATH}; zip -r ../dist.zip * .; cd ..
run aws s3 cp --region $AWS_REGION dist.zip s3://${S3_BUCKET}/${S3_DIST_FILENAME} --content-type application/zip

if [[ "${status}" == "0" ]]; then
  success "Success!"
else
  fail "Error!"
fi
