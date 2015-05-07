#!/usr/bin/env bash

test_db=$1

./ci/before_script.sh $test_db
./ci/script.sh        $test_db
./ci/after_script.sh  $test_db
