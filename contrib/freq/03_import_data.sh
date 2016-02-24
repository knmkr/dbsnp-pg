#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4
FRQ_TOOL=$5

# Set defaults
: ${FRQ_TOOL:=vcftools}

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

# vcftools or plink is required
if type ${FRQ_TOOL} >/dev/null; then
    ${FRQ_TOOL} --version
else
    echo "[contrib/freq] [FATAL] `date +"%Y-%m-%d %H:%M:%S"` ${FRQ_TOOL} not found."
    exit 1
fi

for source_id in ${source_ids[@]}; do
    echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Target sample ids: ${source_id2sample_ids[${source_id}]}"
    echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Drop index if exists ..."
    psql $PG_DB $PG_USER -c "DROP INDEX IF EXISTS allelefreq_${source_id}_snp_id" -q

    for filename in ${source_id2filename[${source_id}]}; do
        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` ${filename}"

        keep_ids=${BASE_DIR}/script/${source_id2sample_ids[${source_id}]}

        if [ "${FRQ_TOOL}" = "vcftools" ]; then
            # vcftools
            echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Calculating freq ..."
            vcftools --freq --out ${filename}.${source_id}.frq --keep ${keep_ids} --gzvcf ${filename}

            echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Formatting ..."
            paste <(gzip -dc ${filename}| grep -v '##'| cut -f 3| tail -n+2) <(cut -f 5- ${filename}.${source_id}.frq.frq| tail -n+2| ${py} ${BASE_DIR}/script/frq2pg_array.py)| \
                ${py} ${BASE_DIR}/script/filter.py --source-id ${source_id} > ${filename}.${source_id}.frq.frq.csv

        elif [ "${FRQ_TOOL}" = "plink" ]; then
            # plink
            echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Calculating freq ..."
            awk '{print $1,$1}' ${keep_ids} > tmp.keep_ids.fam
            plink --vcf ${filename} --make-bed --keep tmp.keep_ids.fam --out tmp
            plink --bfile tmp --freq --out ${filename}.${source_id}.frq
            rm -f tmp.{bed,fam,log,bim,nosex,keep_ids.fam} ${filename}.${source_id}.{log,nosex}

            echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Formatting ..."
            cat ${filename}.${source_id}.frq.frq| ${py} ${BASE_DIR}/script/plinkfrq2pg_array.py| \
                ${py} ${BASE_DIR}/script/filter.py --source-id ${source_id} > ${filename}.${source_id}.frq.frq.csv
        fi

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ..."
        cat ${filename}.${source_id}.frq.frq.csv| psql $PG_DB $PG_USER -c "COPY AlleleFreq FROM stdin DELIMITERS '	' WITH NULL AS ''" -q
    done;

    echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating constraints ..."
    psql $PG_DB $PG_USER -c "CREATE INDEX allelefreq_${source_id}_snp_id ON AlleleFreq_${source_id} (snp_id)" -q

    echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Updating snp_id_current ..."
    psql $PG_DB $PG_USER -c "UPDATE allelefreq_${source_id} \
                             SET snp_id = a.rscurrent \
                             FROM (SELECT rshigh, rscurrent FROM rsmergearch) a \
                             WHERE allelefreq_${source_id}.snp_id = a.rshigh"
    psql $PG_DB $PG_USER -c "DELETE FROM allelefreq_${source_id} WHERE snp_id IS NULL"

done;

# TODO: remove intermediate files

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
