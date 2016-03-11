#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <dbname> <dbuser> <base_dir> <data_dir>" >&2
    exit 1
fi

target=(Allele SnpChrCode RsMergeArch SNP SNPChrPosOnRef)

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing data..."
echo "[INFO] database_name: ${PG_DB}, database_user: ${PG_USER}, base_dir: ${BASE_DIR}, data_dir: ${DATA_DIR}"

cd ${DATA_DIR}

for table in ${target[@]}; do
    for filename in ${table}.bcp.gz; do
        if [ ! -e ${filename} ]; then
            echo "[WARN] `date +"%Y-%m-%d %H:%M:%S"` ${filename} does not exists, so skip importing."
            continue
        fi

        echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ${filename} into ${table}..."
        gzip -d -c ${filename} \
            | tr -d '\15' \
            | nkf -Lu \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''" -q
    done;
done;

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating constrains..."

psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_constraints.sql -q

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
