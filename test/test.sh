#!/usr/bin/env bash

test_db=test_dbsnp_$RANDOM

echo    "[INFO] test_db: ${test_db}"
echo    "[INFO] prepare for test..."
echo -n "[INFO] "; dropdb --if-exists $test_db
echo -n "[INFO] "; createdb $test_db

cd ..;    ./02_drop_create_table.sh $test_db
cd test; ../03_import_dbsnp.sh      $test_db
cd ..;    ./04_add_constraints.sh   $test_db

echo -n "[INFO] "; type pg_prove
if [ $? != 0 ]; then
  echo "[FATAL] pg_prove command not found. abort."
  exit 1
fi

cd test; pg_prove -d $test_db .

# echo "[INFO] test get_freq_by_rs.sql ..."
# psql $test_db -f ../example/get_freq_by_rs.sql

# #
# psql $test_db -c "SELECT get_current_rs(332);"

psql $test_db -c "\di"

echo "[INFO] clean up ${test_db} ..."
dropdb $test_db

echo "[INFO] done"
