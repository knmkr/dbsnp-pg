#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

minimal=(Allele SnpChrCode RsMergeArch b141_SNPChrPosOnRef b141_SNPChrPosOnRef_GRCh37p13 Population AlleleFreqBySsPop SNPSubSNPLink dn_PopulationIndGrp SNPAlleleFreq)
optional=()

target=${minimal[@]}

cd data

for table in ${target[@]}; do
    for filename in ${table}.bcp.gz; do
        echo `date +"%Y-%m-%d %H:%M:%S"` "[INFO] Importing ${filename} into ${table} ..."
        gzip -d -c ${filename} \
            | tr -d '\15' \
            | nkf -Lu \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''" -q

        psql $PG_DB $PG_USER -c "SELECT * FROM ${table} LIMIT 1" -q
    done;
done;

echo `date +"%Y-%m-%d %H:%M:%S"` "[INFO] Done"
