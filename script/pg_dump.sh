#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
TAG=$3
NUM_JOB=$4

# pg_dump -Fd -f ${PG_DB}-${TAG} -j ${NUM_JOB} ${PG_DB} -U ${PG_USER}

pg_dump -T '(allelefreq*|gwascatalog*)' $PG_DB -U $PG_USER > ${PG_DB}-${TAG}.core
pg_dump -t 'allelefreq*' $PG_DB -U $PG_USER > ${PG_DB}-${TAG}.freq
pg_dump -t 'gwascatalog*' $PG_DB -U $PG_USER > ${PG_DB}-${TAG}.gwascatalog
