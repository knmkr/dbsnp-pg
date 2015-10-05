#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

source_ids=(2 100 200)

# TODO: Avoid hardcoding source_ids
declare -A target2filename=( \
  ["1"]="1000genomes.phase1/ALL.chr*.*.vcf*"
  ["2"]="1000genomes.phase3/ALL.chr*.*.vcf*"
  ["3"]="1000genomes.phase1/ALL.chr*.*.vcf*"
  ["4"]="1000genomes.phase3/ALL.chr*.*.vcf*"
  ["5"]="1000genomes.phase3/ALL.chr*.*.vcf*"
  ["6"]="1000genomes.phase3/ALL.chr*.*.vcf*"
  ["100"]="1000genomes.phase3/ALL.chr*.*.vcf*"
  ["200"]="1000genomes.phase3/ALL.chr*.*.vcf*"
)

declare -A target2sample_ids=( \
  ["1"]="sample_ids.1000genomes.phase1.CHB+JPT.txt"
  ["2"]="sample_ids.1000genomes.phase3.CHB+JPT.txt"
  ["3"]="sample_ids.1000genomes.phase1.CHB+JPT+CHS.txt"
  ["4"]="sample_ids.1000genomes.phase3.CHB+JPT+CHS.txt"
  ["5"]="sample_ids.1000genomes.phase3.CHB.txt"
  ["6"]="sample_ids.1000genomes.phase3.JPT.txt"
  ["100"]="sample_ids.1000genomes.phase3.CEU.non-rel.txt"
  ["200"]="sample_ids.1000genomes.phase3.YRI.non-rel.txt"
)

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing data..."
echo "[contrib/freq] [INFO] database_name: ${PG_DB}, database_user: ${PG_USER}, base_dir: ${BASE_DIR}, data_dir: ${DATA_DIR}"

cd ${DATA_DIR}

# Use pypy if available
if type pypy >/dev/null; then
  py=$(which pypy)
else
  py=$(which python)
fi

for target in ${source_ids[@]}; do
    for filename in ${target2filename[${target}]}; do
        if [ ! -e ${filename} ]; then
            continue
        fi

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ${filename} ..."
        ${py} ${BASE_DIR}/script/vcf2freq.py ${filename} --sample-ids ${BASE_DIR}/script/${target2sample_ids[${target}]} \
            | awk -v v="${target}" 'OFS="\t" {print $0,v}' \
            | psql $PG_DB $PG_USER -c "COPY AlleleFreq FROM stdin DELIMITERS '	' WITH NULL AS ''" -q
    done;
done;

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
