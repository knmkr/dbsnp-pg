#!/usr/bin/env bash

set -eu

PG_DB=$1
PG_USER=$2
TAG=$3

RELEASE=release/${TAG}/${PG_DB/dbsnp_/}  # release/x.x.x/bxxx_GRChxx/
mkdir -p ${RELEASE}
cd ${RELEASE}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Fetchging data ..."
PG_DUMP=${PG_DB//_/-}-${TAG}.pg_dump  # dbsnp-bxxx-GRChxx-x.x.x.pg_dump
wget -c https://github.com/knmkr/dbsnp-pg/releases/download/${TAG}/${PG_DUMP}.a{a,b,c,d,e,f,g}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` pg_restore ..."
cat ${PG_DUMP}.a{a,b,c,d,e,f,g} > ${PG_DUMP}
NUM_JOB=$(getconf _NPROCESSORS_ONLN)
pg_restore -v --clean --if-exists -n public -d ${PG_DB} -U ${PG_USER} -j ${NUM_JOB} ${PG_DUMP}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Remove intermediate files"
rm ${PG_DUMP}.a{a,b,c,d,e,f,g}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
