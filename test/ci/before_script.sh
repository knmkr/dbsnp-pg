#!/usr/bin/env bash

test_db=$1
test_user=$2

echo "[INFO] test_db: ${test_db}"
echo "[INFO] prepare for test..."
dropdb --if-exists $test_db
createdb -E UTF8 -O $test_user $test_db

cd ..
  ./02_drop_create_table.sh $test_db $test_user
cd test
  ../03_import_dbsnp.sh     $test_db $test_user
cd ..
  ./04_add_constraints.sh   $test_db $test_user
cd test

echo -n "[INFO] "; type pg_prove
if [ $? != 0 ]; then
  echo "[FATAL] pg_prove command not found. abort."
  exit 1
fi

psql $test_db -U $test_user -c "CREATE EXTENSION IF NOT EXISTS pgtap;"
