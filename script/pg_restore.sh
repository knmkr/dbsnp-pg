#!/usr/bin/env bash

set -eu

if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <PG_DB> <PG_USER> <TAG> <DBSNP_BUILD> <REF_BUILD>" >&2
    exit 1
fi

PG_DB=$1
PG_USER=$2
TAG=$3
DBSNP_BUILD=$4
REF_BUILD=$5

PG_DUMP=dbsnp-${DBSNP_BUILD}-${REF_BUILD}-${TAG}.pg_dump
CHUNKS=$(echo ${PG_DUMP}.a{a,b,c,d,e,f,g,h,i})

if [ ! -f ${PG_DUMP} ]; then
    echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Fetchging data..."
    for chunk in $CHUNKS; do
        wget -c https://github.com/knmkr/dbsnp-pg/releases/download/${TAG}/${chunk};
    done

    echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Concatenating chunks..."
    cat ${CHUNKS} > ${PG_DUMP}
fi

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` pg_restore..."
NUM_JOB=$(getconf _NPROCESSORS_ONLN)
pg_restore -v --clean --if-exists -n public -d ${PG_DB} -U ${PG_USER} -j ${NUM_JOB} ${PG_DUMP}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Remove intermediate files"
rm -f ${CHUNKS}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
