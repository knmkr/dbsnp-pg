#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
TAG=$3
NUM_JOB=$4

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Fetchging data ..."
# wget -c https://github.com/knmkr/dbsnp-pg-min/releases/download/${TAG}/dbsnp-pg-min-${TAG}_b144_GRCh37.pg_dump.sql.gz

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` pg_restore ..."
pg_restore -d ${PG_DB} -U ${PG_USER} -j ${NUM_JOB}
