#!/bin/bash
set -e

create_version_file() {
  VERSION_PATH=version
  if [[ $DIST_PATH ]]; then
    VERSION_PATH=$DIST_PATH/$VERSION_PATH
  fi

cat <<EOF > $VERSION_PATH
Built on:         `date +"%Y-%m-%d %T"`
Pipeline version: ${BITBUCKET_BUILD_NUMBER:=Undefined}
Commit:           ${BITBUCKET_COMMIT:=Undefined}
Repository:       ${BITBUCKET_REPO_SLUG:=Undefined}
Branch:           ${BITBUCKET_BRANCH:=Undefined}
Build command:    ${BUILD_COMMAND:=Undefined}
Package name:     ${S3_FILENAME:=Undefined}
EOF
}
