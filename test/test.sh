#!/usr/bin/env bash

test_db=test_dbsnp_$RANDOM

echo "[INFO] test_db: ${test_db}"
echo "[INFO] prepare for test..."
dropdb --if-exists $test_db
createdb $test_db

cd ..
  ./02_drop_create_table.sh $test_db
cd test
  ../03_import_dbsnp.sh     $test_db
cd ..
  ./04_add_constraints.sh   $test_db

echo -n "[INFO] "; type pg_prove
if [ $? != 0 ]; then
  echo "[FATAL] pg_prove command not found. abort."
  exit 1
fi

cd test
  psql $test_db -c "CREATE EXTENSION IF NOT EXISTS pgtap;"
  pg_prove -d $test_db .

  echo "[INFO] clean up ${test_db} ..."
  dropdb $test_db

  echo "[INFO] done"
