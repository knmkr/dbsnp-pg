#!/usr/bin/env bash

test_db=$1

echo "[INFO] clean up ${test_db} ..."
dropdb $test_db

echo "[INFO] done"
