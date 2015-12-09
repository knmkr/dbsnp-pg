#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
dst=$3

mkdir -p tmp
cd tmp
rm -f ${dst}.*
rm -f gwascatalog_snps.*

psql ${PG_DB} ${PG_USER} -c "SELECT DISTINCT snp_id_current FROM gwascatalog WHERE snp_id_current IS NOT NULL" -A -t| sort -n > gwascatalog_snps.txt
printf "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` #SNPs: "; wc -l gwascatalog_snps.txt
split -l 200 gwascatalog_snps.txt gwascatalog_snps.
rm gwascatalog_snps.txt

# Create data for each populations (EastAsian, European, African, Global)
declare -A population_map=( \
    ["2"]="EAS"
    ["100"]="EUR"
    ["200"]="AFR"
    ["300"]="GL"
)

for source_id in 2 100 200 300; do \
    rm -f ${dst}.tmp

    for chunk in gwascatalog_snps.*; do \
        echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating allele freq data for chunk: ${chunk}"

        printf "SELECT snp_current,allele,freq,'{${population_map[${source_id}]}}' FROM get_tbl_allele_freq_by_rs_history(${source_id}, '{" > q.sql
        cat ${chunk}| tr \\n ,| awk 'sub(/.$/, "", $0)'                                                                                     >> q.sql
        printf "}')\n"                                                                                                                      >> q.sql

        psql ${PG_DB} ${PG_USER} -f q.sql -A -F $'\t' -t >> ${dst}.tmp
    done

    sort -n ${dst}.tmp| uniq > ${dst}.${source_id}

    printf "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` "; wc -l ${dst}.${source_id}
    mv ${dst}.${source_id} ../
done

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
