# bagop

[![Go Report Card](https://goreportcard.com/badge/github.com/swexbe/bagop)](https://goreportcard.com/report/github.com/swexbe/bagop)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/swexbe/bagop)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/swexbe/bagop)

Tool to make automatic backups of any number of docker database containers to AWS Glacier

## Getting Started

Example run command:

```
docker run -e S3_VAULT_NAME=yourvault
    -e AWS_DEFAULT_REGION=eu-north-1
    -e AWS_SECRET_ACCESS_KEY=%%secret%%
    -e AWS_ACCESS_KEY_ID=%%secret%%
    -e SLEEP=7d
    -e TTL=90
    -v /var/run/docker.sock:/var/run/docker.sock
    -d swexbe/bagop:latest
```

- NOTE: CRON must be a valid cron time/date field
- Set the labels `bagop.enable=true` and `bagop.name=dbname` for any dn containers you wish to automatically backup

## Configuration

How to configure bagop.

### Environment Variables for bagop Container

The application is configured through environment variables.

| Key                   | Required | Description                                                                                  | Example   |
| --------------------- | -------- | -------------------------------------------------------------------------------------------- | --------- |
| S3_VAULT_NAME         | yes      | The name of your AWS Glacier Vault                                                           | testvault |
| AWS_REGION            | yes      | The AWS region in which your vault is located                                                | us-east-1 |
| AWS_SECRET_ACCESS_KEY | yes      | Your AWS secret access key                                                                   | secret    |
| AWS_ACCESS_KEY_ID     | yes      | Your AWS access key id                                                                       | secret    |
| SLEEP                 | yes      | Any valid time field for sleep command                                                       | 7d        |
| TTL                   | no       | Time to Live for regular backups (in days). If not set, backups will never expire.           | 90        |
| LT_ITER               | no       | Every n:th backup will be a long-term backup. If not set, no long-term backups will be made. | 5         |
| LT_TTL                | no       | Time to Live for long-term backups (in days) If not set, backups will never expire.          | 365       |

With the above example values set, backups will be made every 7th day. Every 5th backup (every 35th days) will be a long-term backup. Regular backups will be deleted the next time bagop runs after 90 days. Long-term backups will be deleted after 365 days.

Additional environment variables for configuring the connection to AWS and Docker are also available. Documentation for these can be found in [Docker Go SDK docs](https://pkg.go.dev/github.com/docker/docker/client#NewEnvClient) and [AWS for Go docs](https://docs.aws.amazon.com/sdk-for-go/v1/developer-guide/configuring-sdk.html).

### Labels for Database Containers

To configure backups for an individual container, the following docker labels can be set:

| Key          | Required | Description                                                                                                                 |
| ------------ | -------- | --------------------------------------------------------------------------------------------------------------------------- |
| bagop.enable | yes      | Enable bagop for this container if set to `true`                                                                            |
| bagop.name   | no       | The name of the resulting .sql file for this container, will use docker id if not set                                       |
| bagop.vendor | no       | can be set to `postgres` or `mysql`. Overrides vendor detection and forces bagop to treat the container as the given vendor |

### Volumes

The following directories can be mounted on the filesystem:

| Directory    | Description                                                                                     |
| ------------ | ----------------------------------------------------------------------------------------------- |
| `/extra`     | Anything mounted in this directory will be added to each backup                                 |
| `/var/bagop` | Persistent data will be stored in this directory, i.e. Glacier archive IDs and their expiration |

### Input Parameters

Manual backups can be run using docker exec or interactive shell. The following input parameters are available:

| Flag | Description |
|----------|------------------------------------------------------------------------|
| -v | Verbose mode |
| -b | Make a backup |
| -c | Delete expired containers from Glacier |
| -ttl= | Time to Live for backup in days. If not set, backup will never expire. |
| -version | Display version |

## Contributions

Would be appreciated
