#!/usr/bin/env bash

set -eu

PG_DB=$1
PG_USER=$2
TAG=$3

echo "[INFO] `date +"%Y-%m-%d %H:%M:%S"` pg_dump ..."
pg_dump -Fc $PG_DB -U $PG_USER > ${PG_DB//_/-}.${TAG}.pg_dump
