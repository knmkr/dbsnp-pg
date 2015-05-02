#!/usr/bin/env bash

test_db=test_dbsnp_$RANDOM

echo "[INFO] test_db: ${test_db}"
echo "[INFO] prepare for test..."
dropdb --if-exists $test_db
createdb $test_db

cd ..;    ./02_drop_create_table.sh $test_db
cd test; ../03_import_dbsnp.sh      $test_db
cd ..;    ./04_add_constraints.sh   $test_db
cd test

echo "[INFO] test get_freq_by_rs.sql ..."
psql $test_db -f ../example/get_freq_by_rs.sql

#
psql $test_db -c "SELECT get_current_rs(332);"

echo "[INFO] clean up ${test_db} ..."
dropdb $test_db

echo "[INFO] done"
