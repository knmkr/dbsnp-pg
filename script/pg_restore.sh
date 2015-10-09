#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
TAG=$3
NUM_JOB=$4

BASE_URL=https://github.com/knmkr/dbsnp-pg-min/releases/download
TARGET=dbsnp_b144_GRCh37

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Fetchging data ..."
wget -c ${BASE_URL}/${TAG}/${TARGET}-${TAG}.pg_dump
wget -c ${BASE_URL}/${TAG}/${TARGET}-${TAG}.freq.pg_dump
wget -c ${BASE_URL}/${TAG}/${TARGET}-${TAG}.gwascatalog.pg_dump

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` pg_restore ..."
for fin in ${TARGET}-${TAG}*; do
    pg_restore -d ${PG_DB} -U ${PG_USER} -j ${NUM_JOB} ${fin}
done
