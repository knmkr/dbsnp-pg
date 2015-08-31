#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

target=(AlleleFreqIn1000GenomesPhase1_b37)

declare -A table2filename=( \
  ["AlleleFreqIn1000GenomesPhase1_b37"]="ALL.chr*.*.vcf"
  ["AlleleFreqIn1000GenomesPhase3_b37"]="ALL.chr*.*.vcf"
)

declare -A table2sample_ids=( \
  ["AlleleFreqIn1000GenomesPhase1_b37"]="sample_ids.1000genomes.phase1.CHB+JPT+CHS.txt"
  ["AlleleFreqIn1000GenomesPhase3_b37"]="sample_ids.1000genomes.phase1.CHB+JPT.txt"
)

# Skip non-unique rsids in original vcf.  # FIXME: Need to be revised.
declare -A table2exclude_rsids=( \
  ["AlleleFreqIn1000GenomesPhase1_b37"]="113940759 11457237 71904485"
  ["AlleleFreqIn1000GenomesPhase3_b37"]=""
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
              ${filename} \
              --sample-ids ${BASE_DIR}/script/${table2sample_ids[${table}]} \
              --exclude-rsids ${table2exclude_rsids[${table}]} \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''" -q
    done;
done;

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
