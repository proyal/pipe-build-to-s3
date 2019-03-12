#!/bin/bash
#
# This pipe executes a command to build a node project, zips it up, and uploads it to s3.
#

source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/create-version-file.sh"

#
# Required parameters
#
AWS_REGION=${AWS_REGION:?'AWS_REGION variable missing.'}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?'AWS_SECRET_ACCESS_KEY variable missing.'}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?'AWS_ACCESS_KEY_ID variable missing.'}
S3_BUCKET=${S3_BUCKET:?'S3_BUCKET variable missing.'}
S3_FILENAME=${S3_FILENAME:?'S3_FILENAME variable missing.'}

#
# Default parameters
#
S3_FILENAME_REGEX=${S3_FILENAME_REGEX:='^[a-zA-Z0-9_/-]+\.zip$'}
DIST_PATH=${DIST_PATH:='.dist'}
RUN_DEPENDENCIES_COMMAND=${RUN_DEPENDENCIES_COMMAND:='true'}
DEPENDENCIES_COMMAND=${DEPENDENCIES_COMMAND:='npm ci'}
RUN_LINT_COMMAND=${RUN_LINT_COMMAND:='true'}
LINT_COMMAND=${LINT_COMMAND:='npm run lint'}
BUILD_COMMAND=${BUILD_COMMAND:='npm run build'}

if [[ ! $S3_FILENAME =~ $S3_FILENAME_REGEX ]];
then
  fail "S3_FILENAME might not be set as intended. Value '${S3_FILENAME}' does not match $S3_FILENAME_REGEX"
fi

#
# Echo non-sensitive variables that are about to be used.
#
echo_var AWS_REGION
echo_var S3_BUCKET
echo_var S3_FILENAME
echo
echo_var S3_FILENAME_REGEX
echo_var DIST_PATH
echo_var RUN_DEPENDENCIES_COMMAND
echo_var DEPENDENCIES_COMMAND
echo_var RUN_LINT_COMMAND
echo_var LINT_COMMAND
echo_var BUILD_COMMAND

#
# Begin the work.
#
run rm -rf $DIST_PATH
if [[ "$RUN_DEPENDENCIES_COMMAND" == "true" ]]; then
  run ${DEPENDENCIES_COMMAND}
fi
if [[ "$RUN_LINT_COMMAND" == "true" ]]; then
  run ${LINT_COMMAND}
fi
run ${BUILD_COMMAND}
run create_version_file
run "cd ${DIST_PATH}; zip -r ../dist.zip .; cd .."
run aws s3 cp --region $AWS_REGION dist.zip s3://${S3_BUCKET}/${S3_FILENAME} --content-type application/zip
