#!/usr/bin/env bash

test_db=$1

./before_script.sh $test_db
./script.sh        $test_db
./after_script.sh  $test_db
