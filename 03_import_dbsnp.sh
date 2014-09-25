#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

minimal=(Allele Population AlleleFreqBySsPop dn_PopulationIndGrp SNPSubSNPLink)
optional=(SnpChrCode SNPAlleleFreq RsMergeArch b141_SNPChrPosOnRef)

target=${minimal[@]}

for table in ${target[@]}; do
    for filename in ${table}.bcp.gz*; do
        echo "[INFO] Importing ${filename} into ${table} ..."
        gzip -d -c ${filename} \
            | tr -d '\15' \
            | nkf -Lu \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''"

        psql $PG_DB $PG_USER -c "SELECT * FROM ${table} LIMIT 5"
    done;
done;

echo "[INFO] Done"
