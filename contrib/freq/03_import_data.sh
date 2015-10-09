#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

# source_ids=(2 100 200)
source_ids=(2)

# TODO: Avoid hardcoding source_ids
declare -A target2filename=( \
  ["1"]="1000genomes.phase1/ALL.chr*.*.vcf.gz"
  ["2"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["3"]="1000genomes.phase1/ALL.chr*.*.vcf.gz"
  ["4"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["5"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["6"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["100"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["200"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
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

# vcftools is required
if type vcftools >/dev/null; then
  vcftools --version
else
  echo "[contrib/freq] [FATAL] `date +"%Y-%m-%d %H:%M:%S"` vcftools not found."
  exit 1
fi

for target in ${source_ids[@]}; do
    for filename in ${target2filename[${target}]}; do
        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"`" ${filename}
        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Calculating freq ..."
        vcftools --freq --out ${filename}.frq --keep ${BASE_DIR}/script/${target2sample_ids[${target}]} --gzvcf ${filename}

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Formatting ..."
        paste <(gzip -dc ${filename}| grep -v '##'| cut -f 3| tail -n+2) <(cut -f 5- ${filename}.frq.frq| tail -n+2| ${py} ${BASE_DIR}/script/frq2pg_array.py)| \
            ${py} ${BASE_DIR}/script/filter.py --source-id ${target} > ${filename}.frq.frq.csv

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ..."
        cat ${filename}.frq.frq.csv| psql $PG_DB $PG_USER -c "COPY AlleleFreq FROM stdin DELIMITERS '	' WITH NULL AS ''" -q
    done;
done;

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating constraints ..."
psql $PG_DB $PG_USER -f ${BASE_DIR}/postgresql/schema/create_constraints.sql -q

# TODO: remove intermediate files

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
