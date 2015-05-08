#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

psql $PG_DB $PG_USER -f ./postgresql/schema/create_tables.sql -q
psql $PG_DB $PG_USER -f ./postgresql/schema/create_functions.sql -q

server_version_num=$(psql $PG_DB $PG_USER -tc "SHOW server_version_num")  # e.g. 90300 (= PostgreSQL 9.3.0)

if [ "$server_version_num" -ge 90300 ]; then
  echo "[INFO] PostgreSQL >= 9.3"
  psql $PG_DB $PG_USER -f ./postgresql/schema/create_functions_9.3.sql -q
fi

echo "[INFO] Done"
