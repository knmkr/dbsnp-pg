#!/usr/bin/env bash

test_db=$1
test_user=$2

pg_prove -d $test_db -U $test_user *.sql
