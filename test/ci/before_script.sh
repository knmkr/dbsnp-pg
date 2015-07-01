#!/usr/bin/env bash

test_db=$1
test_user=$2
base_dir=$3

echo "[INFO] preparing test database: ${test_db}..."
for src in ${base_dir} ${base_dir}/contrib/*; do
    ${src}/02_drop_create_table.sh $test_db $test_user $src
    ${src}/03_import_data.sh       $test_db $test_user $src ${src}/test/data
done

echo "[INFO] preparing test command (pg_prove)..."
echo -n "[INFO] "; type pg_prove
if [ $? != 0 ]; then
  echo "[FATAL] pg_prove command not found. abort."
  exit 1
fi

psql $test_db $test_user -c "CREATE EXTENSION IF NOT EXISTS pgtap;"
