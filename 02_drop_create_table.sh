#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <dbname> <dbuser> <base_dir>" >&2
    exit 1
fi

echo "[INFO] Drop and Create tables..."
echo "[INFO] database_name: ${PG_DB}, database_user: ${PG_USER}, base_dir: ${BASE_DIR}"

psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_tables.sql -q
psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_functions.sql -q

server_version_num=$(psql $PG_DB $PG_USER -tc "SHOW server_version_num")  # e.g. 90300 (= PostgreSQL 9.3.0)

if [ "$server_version_num" -ge 90300 ]; then
  echo "[INFO] PostgreSQL >= 9.3"
  psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_functions_9.3.sql -q
fi

echo "[INFO] Done"
