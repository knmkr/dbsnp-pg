#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

dst=gwascatalog_snps_allele_freq_$(date +"%Y-%m-%d").tsv

mkdir -p tmp
cd tmp
rm -f ${dst}
rm -f gwascatalog_snps.*

psql ${PG_DB} ${PG_USER} -c "SELECT DISTINCT snp_id FROM gwascatalog WHERE snp_id IS NOT NULL" -A -t| sort -n > gwascatalog_snps.txt
printf "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` #SNPs: "; wc -l gwascatalog_snps.txt
split -l 500 gwascatalog_snps.txt gwascatalog_snps.
rm gwascatalog_snps.txt

for chunk in gwascatalog_snps.*; do \
    echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating allele freq data for chunk: ${chunk}"

    printf 'SELECT snp_id,snp_current,allele,freq FROM get_tbl_allele_freq_by_rs_history(4, ARRAY[' > q.sql
    cat ${chunk}| perl -ne 'print $_.chomp; print "," if not eof'                                   >> q.sql
    printf ']) WHERE freq IS NOT NULL'                                                              >> q.sql

    psql ${PG_DB} ${PG_USER} -f q.sql -A -F $'\t' -t| awk -F $'\t' '{OFS="\t"; print $1,$2,$3,$4,"{CHB,JPT}"}' >> ${dst}
done

mv ${dst} ../
cd ../
rm -r tmp

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"