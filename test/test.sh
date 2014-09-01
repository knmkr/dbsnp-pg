#!/usr/bin/env bash

test_db=dbsnp_b141_test_$RANDOM

echo "[INFO] test_db: ${test_db}"
echo "[INFO] prepare for test..."
dropdb $test_db
createdb $test_db
psql $test_db -f ../drop_create_table.sql
../import_dbsnp.sh $test_db

echo "[INFO] test get_freq_by_rs.sql ..."
psql $test_db -f ../example/get_freq_by_rs.sql

echo "[INFO] clean up ${test_db} ..."
dropdb $test_db

echo "[INFO] done"
