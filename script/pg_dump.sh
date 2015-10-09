#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
TAG=$3
NUM_JOB=$4

pg_dump -Fc -T '(allelefreq*|gwascatalog*)' $PG_DB -U $PG_USER > ${PG_DB}-${TAG}.pg_dump
pg_dump -Fc -t 'allelefreq*' $PG_DB -U $PG_USER > ${PG_DB}-${TAG}.freq.pg_dump
pg_dump -Fc -t 'gwascatalog*' $PG_DB -U $PG_USER > ${PG_DB}-${TAG}.gwascatalog.pg_dump
