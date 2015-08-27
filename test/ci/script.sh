#!/usr/bin/env bash

test_db=$1
test_user=$2
base_dir=$3

pg_prove -d $test_db -U $test_user \
         ${base_dir}/test/*.sql \
         ${base_dir}/contrib/*/test/*.sql
