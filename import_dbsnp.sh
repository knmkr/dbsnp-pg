#!/usr/bin/env bash

DBSNP_DB=$1
DBSNP_USER=$2

for bcp in Allele RsMergeArch b141_SNPChrPosOnRef; do
  echo "[INFO] Importing ${bcp}..."
  gunzip -c ${bcp}.bcp.gz | nkf -Lu | psql $DBSNP_DB $DBSNP_USER -c "COPY ${bcp} FROM stdin DELIMITERS '	' WITH NULL AS ''"
  psql $DBSNP_DB $DBSNP_USER -c "SELECT * FROM ${bcp} LIMIT 5"
done;

echo "[INFO] Done"
