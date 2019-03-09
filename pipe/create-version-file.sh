#!/bin/bash
set -e

DIST_PATH=${DIST_PATH:?'DIST_PATH variable missing.'}

cat <<EOF > ${DIST_PATH}/version
Built on:           `date +"%Y-%m-%d %T"`
Pipeline version:   ${BITBUCKET_BUILD_NUMBER:=local}
Commit:             ${BITBUCKET_COMMIT:=local}
Repository:         ${BITBUCKET_REPO_SLUG:=local}
Branch:             ${BITBUCKET_BRANCH:=local}
Target environment: ${TARGET_ENV:=default}
EOF
