#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

dst=gwascatalog_cleaned_$(date +"%Y-%m-%d").tsv

mkdir -p tmp
cd tmp
rm -f ${dst}

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating ${dst} ..."

psql ${PG_DB} ${PG_USER} -c "\COPY (SELECT * FROM gwascatalog WHERE snp_id IS NOT NULL) TO STDOUT DELIMITER '	' CSV HEADER " > ${dst}
printf "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` #records: "; wc -l ${dst}

mv ${dst} ../
cd ../
rm -r tmp

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
