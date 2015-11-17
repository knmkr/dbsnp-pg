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

# TODO: Create data for each populations (EastAsian, European, African)
for chunk in gwascatalog_snps.*; do \
    echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating allele freq data for chunk: ${chunk}"

    printf "SELECT snp_current,allele,freq FROM get_tbl_allele_freq_by_rs_history(2, '{"     > q.sql
    cat ${chunk}| tr \\n ,| awk 'sub(/.$/, "", $0)'                                             >> q.sql
    printf "}')\n"                                                                              >> q.sql

    psql ${PG_DB} ${PG_USER} -f q.sql -A -F $'\t' -t| awk -F $'\t' '{OFS="\t"; print $1,$2,$3,"{CHB,JPT}"}' >> ${dst}.tmp
done

sort -n ${dst}.tmp| uniq > ${dst}

printf "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` "; wc -l ${dst}
mv ${dst} ../

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
