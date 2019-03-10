# pipe-build-to-s3

Bitbucket pipeline pipe to build a project, zip it up, and upload it to s3.

## YAML Definition

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
script:
  - pipe: proyal/pipe-build-to-s3:1.0.0
    variables:
      AWS_REGION: "<string>"
      AWS_SECRET_ACCESS_KEY: "<string>"
      AWS_ACCESS_KEY_ID: "<string>"
      S3_BUCKET: "<string>"
      S3_FILENAME: "<string>"
      DIST_PATH: "<string>"                # Optional
      RUN_LINT_COMMAND: <true/false>       # Optional
      BUILD_COMMAND: "<string>"            # Optional
      S3_FILENAME_REGEX: "<string>"        # Set to .* avoid filename validation.
```

## Variables

| Variable                  | Usage                                                       |
| ---------------------     | ----------------------------------------------------------- |
| AWS_REGION (*)            | AWS region. |
| AWS_SECRET_ACCESS_KEY (*) | AWS secret access key. |
| AWS_ACCESS_KEY_ID (*)     | AWS access key id. |
| S3_BUCKET (*)             | S3 bucket name. |
| S3_FILENAME (*)           | S3 upload filename, including path. Example: `${BITBUCKET_REPO_SLUG}_${BITBUCKET_COMMIT}.zip`. |
| DIST_PATH                 | Path to directory which is built to, and whose contents are zipped. Default: `.dist` |
| RUN_DEPENDENCIES_COMMAND  | If false, will not run the dependency command. Default: `true` |
| DEPENDENCIES_COMMAND      | Command to install dependencies prior to build. Default: `npm ci` |
| RUN_LINT_COMMAND          | If false, will not run the lint command. Default: `true` |
| LINT_COMMAND              | Command to lint the project prior to build. Default: `npm run lint` |
| BUILD_COMMAND             | Command to build all artifacts to DIST_PATH. Default: `npm run build` |
| S3_FILENAME_REGEX         | Regex string to validate S3_FILENAME. Default: `^[a-zA-Z0-9_/-]+\.zip$` |

_(*) = required variable._
