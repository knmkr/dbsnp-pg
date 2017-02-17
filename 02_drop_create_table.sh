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

echo "[INFO] Done"
