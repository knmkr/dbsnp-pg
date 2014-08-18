#!/usr/bin/env bash

DBSNP_DB=$1
DBSNP_USER=$2

minimal=(Allele RsMergeArch b141_SNPChrPosOnRef Population AlleleFreqBySsPop SNPSubSNPLink SnpChrCode)
optional=(SnpChrCode SNPAlleleFreq)

# for bcp in $minimal; do
for bcp in SNPSubSNPLink; do
  echo "[INFO] Importing ${bcp}..."
  gunzip -c ${bcp}.bcp.gz | tr -d '\15' | nkf -Lu |  psql $DBSNP_DB $DBSNP_USER -c "COPY ${bcp} FROM stdin DELIMITERS '	' WITH NULL AS ''"
  psql $DBSNP_DB $DBSNP_USER -c "SELECT * FROM ${bcp} LIMIT 5"
done;

echo "[INFO] Done"
