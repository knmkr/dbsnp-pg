#!/usr/bin/env bash

set -eu

PG_DB=$1
PG_USER=$2
TAG=$3

BASE_URL=https://github.com/knmkr/dbsnp-pg/releases/download
TARGET=dbsnp-pg-${TAG}-${PG_DB//_/-}  # replace `_` to `-`

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Fetchging data ..."
wget -c ${BASE_URL}/${TAG}/${TARGET}.pg_dump.a{a,b,c,d,e}
cat ${TARGET}.pg_dump.a{a,b,c,d,e} > ${TARGET}.pg_dump
rm ${TARGET}.pg_dump.a{a,b,c,d,e}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` pg_restore ..."
NUM_JOB=$(getconf _NPROCESSORS_ONLN)
pg_restore -C -d ${PG_DB} -U ${PG_USER} -j ${NUM_JOB} ${TARGET}.pg_dump
