#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

dst=gwascatalog-cleaned-$(date +"%Y-%m-%d").tsv

mkdir -p tmp
cd tmp

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating ${dst} ..."

psql ${PG_DB} ${PG_USER} -c "\COPY (SELECT * FROM gwascatalog) TO STDOUT DELIMITER '	' CSV HEADER " > ${dst}
printf "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` #records: "; wc -l ${dst}

mv ${dst} ../

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
