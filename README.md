# schemadiff docker image
This alpine-based multi-arch image contains [schemadiff](https://github.com/kmenta/schemadiff)
and [mariadb-dump](https://mariadb.com/docs/server/clients-and-utilities/backup-restore-and-import-clients/mariadb-dump) tools.
Thanks to this you can easily download and compare two database schemas and see the potential differences.

**Warning:** MySQL's syntax comments are removed from the dumps thus the output is not 100% compatible with MySQL and should be used carefully.

## Usage
```shell
docker run --rm \
  kmenta/schemadiff:v1.0.0 \
  /bin/sh -c \
    'mariadb-dump <local_database_name> \
      -h <host> \
      -u"<username>" \
      -p"<password>" \
      --lock-tables=false \
      --no-data \
      --no-tablespaces \
      --no-set-names \
      --skip-comments \
      --skip-add-drop-table \
      --compact \
      --ssl=false \
    | sed "s/^\/\*![0-9]\{5\}.*\/;$//g" > local_db_schema.sql \
    && mariadb-dump <prod_database_name> \
       -h <host> \
       -u"<username>" \
       -p"<password>" \
       --lock-tables=false \
       --no-data \
       --no-tablespaces \
       --no-set-names \
       --skip-comments \
       --skip-add-drop-table \
       --compact \
       --ssl=false \
     | sed "s/^\/\*![0-9]\{5\}.*\/;$//g" > prod_db_schema.sql \
    && schemadiff diff --source=./local_db_schema.sql --target=./prod_db_schema.sql'
```

## Development
### Prerequisites
`$ docker login -u <username> registry.hub.docker.com` and use your personal access token ([PAT](https://app.docker.com/accounts/kmenta/settings/personal-access-tokens)).

### Build & push
After any change, the image version should be increased in the _Makefile_, then run:

`$ make`

### Removing builder
`$ make remove_builder`