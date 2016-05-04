#!/usr/bin/env bash

set -eu

PG_DB=$1
PG_USER=$2
TAG=$3

PG_DUMP=${PG_DB//_/-}.${TAG}.pg_dump  # replace `_` to `-`

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Fetchging data ..."
wget -c https://github.com/knmkr/dbsnp-pg/releases/download/${TAG}/${PG_DUMP}.a{a,b,c,d,e}
cat ${PG_DUMP}.a{a,b,c,d,e} > ${PG_DUMP}
rm ${PG_DUMP}.a{a,b,c,d,e}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` pg_restore ..."
NUM_JOB=$(getconf _NPROCESSORS_ONLN)
pg_restore -C -d ${PG_DB} -U ${PG_USER} -j ${NUM_JOB} ${PG_DUMP}
