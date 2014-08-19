#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

minimal=(SNPSubSNPLink)  # (Allele RsMergeArch b141_SNPChrPosOnRef Population AlleleFreqBySsPop SNPSubSNPLink)
optional=(SnpChrCode SNPAlleleFreq)

target=($minimal)

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
