#!/usr/bin/env bash

test_db=$1

pg_prove -d $test_db .
