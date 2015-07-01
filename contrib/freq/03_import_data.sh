#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

target=(AlleleFreqIn1000GenomesPhase3_b37)

declare -A table2filename=( \
  ["AlleleFreqIn1000GenomesPhase3_b37"]="ALL.wgs.phase3_shapeit2_mvncall_integrated_v5a.20130502.sites.vcf.gz"
)

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing data..."

cd ${DATA_DIR}

# Use pypy if available
if type pypy >/dev/null; then
  py=$(which pypy)
else
  py=$(which python)
fi

for table in ${target[@]}; do
    for filename in ${table2filename[${table}]}; do
        if [ ! -e ${filename} ]; then
            echo "[contrib/freq] [WARN] `date +"%Y-%m-%d %H:%M:%S"` ${filename} does not exists, so skip importing."
            continue
        fi

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ${filename} into ${table} ..."
        gzip -d -c ${filename} \
            | ${py} ${BASE_DIR}/script/vcf2tsv.py \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''" -q
    done;
done;

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating constrains..."

psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_constraints.sql -q

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
