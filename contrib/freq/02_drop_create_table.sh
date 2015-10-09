#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3

echo "[contrib/freq] [INFO] Drop and Create tables..."
echo "[contrib/freq] [INFO] database_name: ${PG_DB}, database_user: ${PG_USER}, base_dir: ${BASE_DIR}"

psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_tables.sql -q
psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_functions.sql -q

echo "[contrib/freq] [INFO] Done"
