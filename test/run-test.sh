#!/usr/bin/env bash

test_db=$1
test_user=$2
base_dir=$3

if [ $# -ne 3 ]; then
    echo "USAGE: $0 <test_db> <test_user> <base_dir>"
    exit 1
elif [ ! -e ${base_dir}/01_fetch_data.sh ]; then
    echo "[FATAL] base_dir should contains 01_fetch_data.sh"
    exit 1
fi

echo "[INFO] test_db: ${test_db}"
echo "[INFO] test_user: ${test_user}"
echo "[INFO] base_dir: ${base_dir}"

${base_dir}/test/ci/before_script.sh $test_db $test_user $base_dir
${base_dir}/test/ci/script.sh        $test_db $test_user $base_dir
${base_dir}/test/ci/after_script.sh  $test_db $test_user $base_dir
