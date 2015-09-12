#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3

echo "[contrib/gwascatalog] [INFO] Drop and Create tables..."

psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_tables.sql -q

echo "[contrib/gwascatalog] [INFO] Done"
