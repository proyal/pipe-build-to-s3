# pipe-build-to-s3

Bitbucket pipeline pipe to build a project, zip it up, and upload it to s3.

## YAML Definition

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
script:
  - pipe: proyal/pipe-build-to-s3:1.0.0
    variables:
      DIST_PATH: "<string>"
      BUILD_COMMAND: "<string>"
      # AWS_REGION: "<string>"             # Recommend specifying in repo or account variables.
      # AWS_SECRET_ACCESS_KEY: "<string>"  # Recommend specifying in repo or account variables.
      # AWS_ACCESS_KEY_ID: "<string>"      # Recommend specifying in repo or account variables.
      # S3_BUCKET: "<string>"              # Recommend specifying in repo or account variables.
      # S3_DIST_FILENAME: "<string>"       # Optional - The following three EVs determine the default name.
      # BITBUCKET_REPO_SLUG: "<string>"    # Optional
      # BITBUCKET_COMMIT: "<string>"       # Optional
      # TARGET_ENV: "<string>"             # Optional
```

## Variables

| Variable                  | Usage                                                       |
| ---------------------     | ----------------------------------------------------------- |
| DIST_PATH (*)             | Path to directory which is built to, and whose contents are zipped. |
| BUILD_COMMAND             | Command to build all artifacts to DIST_PATH. Default: `npm run build` |
| AWS_REGION (*)            | AWS region. |
| AWS_SECRET_ACCESS_KEY (*) | AWS secret access key. |
| AWS_ACCESS_KEY_ID (*)     | AWS access key id. |
| S3_BUCKET (*)             | S3 bucket name. |
| S3_DIST_FILENAME          | S3 upload filename. Default: `${BITBUCKET_REPO_SLUG}_${BITBUCKET_COMMIT}[_${TARGET_ENV}].zip`. |
| BITBUCKET_REPO_SLUG       | Required only if S3_DIST_FILENAME is not provided. |
| BITBUCKET_COMMIT          | Required only if S3_DIST_FILENAME is not provided. |
| TARGET_ENV                | Required only if S3_DIST_FILENAME is not provided. |

_(*) = required variable._
