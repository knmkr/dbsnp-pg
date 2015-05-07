#!/usr/bin/env bash

test_db=$1

echo "[INFO] test_db: ${test_db}"
echo "[INFO] prepare for test..."
# dropdb --if-exists $test_db
createdb $test_db

cd ..
  ./02_drop_create_table.sh $test_db
cd test
  ../03_import_dbsnp.sh     $test_db
cd ..
  ./04_add_constraints.sh   $test_db
cd test

echo -n "[INFO] "; type pg_prove
if [ $? != 0 ]; then
  echo "[FATAL] pg_prove command not found. abort."
  exit 1
fi

psql $test_db -c "CREATE EXTENSION IF NOT EXISTS pgtap;"
