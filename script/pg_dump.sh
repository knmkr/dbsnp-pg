#!/usr/bin/env bash

set -eu

PG_DB=$1
PG_USER=$2
TAG=$3

NAME=${PG_DB//_/-}-${TAG}

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` pg_dump ..."
pg_dump -Fc $PG_DB -U $PG_USER -T 'allelefreq*' > ${NAME}.pg_dump
pg_dump -Fc $PG_DB -U $PG_USER -t 'allelefreq*' > ${NAME}.freq.pg_dump

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` split ..."
split -b 999m ${NAME}.pg_dump ${NAME}.pg_dump.
split -b 999m ${NAME}.freq.pg_dump ${NAME}.freq.pg_dump.

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
