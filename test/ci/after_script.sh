#!/usr/bin/env bash

test_db=$1
test_user=$2
base_dir=$3

echo "[INFO] clean up ${test_db} ..."

for src in ${base_dir} ${base_dir}/contrib/*; do
    :
done

echo "[INFO] done"
