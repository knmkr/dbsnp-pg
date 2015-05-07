#!/usr/bin/env bash

test_db=$1
test_user=$2

echo "[INFO] test_db: ${test_db} test_user: ${test_user}"
dropdb --if-exists $test_db
createdb -E UTF8 -O $test_user $test_db

./ci/before_script.sh $test_db $test_user
./ci/script.sh        $test_db $test_user
./ci/after_script.sh  $test_db $test_user
