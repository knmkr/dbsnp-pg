#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

target=(_b141_SNPChrPosOnRef_GRCh37p13)

for table in ${target[@]}; do
    for filename in ${table}.bcp.gz*; do
        echo "[INFO] Importing ${filename} into ${table} ..."
        gzip -dc ${filename} \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''"
    done;
done;

echo "[INFO] Done"
