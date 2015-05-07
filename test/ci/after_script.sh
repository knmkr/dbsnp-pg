#!/usr/bin/env bash

test_db=$1
test_user=$2

echo "[INFO] clean up ${test_db} ..."
dropdb -U $test_user $test_db

echo "[INFO] done"
