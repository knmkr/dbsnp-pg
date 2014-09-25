#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

# Create tmp table for query rs list
psql $PG_DB $PG_USER -f _drop_create_query_table.sql

# Import query rs list
awk '$1 ~ /^rs[0-9]+$/ {print $1}' rsList.txt| sed 's/rs//'| psql $PG_DB $PG_USER -c "COPY tmp_rs2current (rsHigh) FROM stdin"

# Update rs# to current rs#
psql $PG_DB $PG_USER -f _update_to_current_rs.sql

# Get freqs
psql $PG_DB $PG_USER -f _get_freq_by_rs.sql
