#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

target=(AlleleFreqIn1000GenomesPhase3_b37)

declare -A table2filename=( \
  ["AlleleFreqIn1000GenomesPhase3_b37"]="ALL.chr*.*.vcf.gz"
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
        ${py} ${BASE_DIR}/script/get-allele-freq.py \
              --sample-ids ${BASE_DIR}/script/sample_ids.1000genomes.CHB+JPT.txt \
              ${filename} \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''" -q
    done;
done;

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
