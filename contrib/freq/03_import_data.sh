#!/usr/bin/env bash

set -e
set -o pipefail

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

source_ids=(3 4 100 200 300)

# TODO: Avoid hardcoding source_ids
declare -A source_id2filename=( \
  ["1"]="1000genomes.phase1/ALL.chr*.*.vcf.gz"
  ["2"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["3"]="1000genomes.phase1/ALL.chr*.*.vcf.gz"
  ["4"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["100"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["200"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
  ["300"]="1000genomes.phase3/ALL.chr*.*.vcf.gz"
)

declare -A source_id2sample_ids=( \
  ["1"]="sample_ids.1000genomes.phase1.JPT.txt"
  ["2"]="sample_ids.1000genomes.phase3.JPT.txt"
  ["3"]="sample_ids.1000genomes.phase1.CHB+JPT+CHS.txt"
  ["4"]="sample_ids.1000genomes.phase3.CHB+JPT+CHS.txt"
  ["100"]="sample_ids.1000genomes.phase3.CEU.no-pat-mat.txt"
  ["200"]="sample_ids.1000genomes.phase3.YRI.no-pat-mat.txt"
  ["300"]="sample_ids.1000genomes.phase3.no-pat-mat.txt"
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

# plink is required
if type plink >/dev/null; then
    :
else
    echo "[contrib/freq] [FATAL] `date +"%Y-%m-%d %H:%M:%S"` plink not found."
    exit 1
fi

psql="psql $PG_DB $PG_USER --no-psqlrc --single-transaction "

for source_id in ${source_ids[@]}; do
    echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Target sample ids: ${source_id2sample_ids[${source_id}]}"

    echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Drop index if exists ..."
    $psql -q -c "DROP INDEX IF EXISTS allelefreq_${source_id}_snp_id"

    keep_ids=${source_id2sample_ids[${source_id}]}
    awk '{print $1,$1}' ${BASE_DIR}/script/${keep_ids} > ${keep_ids}.fam

    for filename in ${source_id2filename[${source_id}]}; do
        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` ${filename}"

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Create .bed if not exists ..."
        if [ ! -f ${filename}.bim ] || [ ! -f ${filename}.bed ] || [ ! -f ${filename}.fam ]; then
            plink --vcf ${filename} --make-bed --out ${filename}
        fi

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Calculating freq ..."
        plink --bfile ${filename} --freq --keep ${keep_ids}.fam --out ${filename}.${source_id}

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Formatting and filtering..."
        cat ${filename}.${source_id}.frq| \
            ${py} ${BASE_DIR}/script/plinkfrq2pg_array.py| \
            ${py} ${BASE_DIR}/script/filter.py --source-id ${source_id} \
            > ${filename}.${source_id}.frq.csv

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ..."
        cat ${filename}.${source_id}.frq.csv| $psql -q -c "COPY AlleleFreq FROM stdin DELIMITERS '	' WITH NULL AS ''"
    done;

    echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating constraints ..."
    $psql -q -c "CREATE INDEX allelefreq_${source_id}_snp_id ON AlleleFreq_${source_id} (snp_id)"

    echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Updating snp_id_current ..."
    $psql -c "DELETE FROM allelefreq_${source_id} USING rsmergearch m WHERE snp_id = m.rshigh AND m.rscurrent IS NULL"
    $psql -c "UPDATE allelefreq_${source_id} a SET snp_id = m.rscurrent FROM rsmergearch m WHERE a.snp_id = m.rshigh"

    $psql -c "UPDATE allelefreqsource s SET status = 'ok' WHERE s.source_id = ${source_id}"

done;


echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
