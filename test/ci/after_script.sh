#!/usr/bin/env bash

test_db=$1
test_user=$2

echo "[INFO] clean up ${test_db} ..."

psql $test_db -U $test_user -c "
TRUNCATE TABLE Allele;
TRUNCATE TABLE SnpChrCode;
TRUNCATE TABLE RsMergeArch;
TRUNCATE TABLE SNPChrPosOnRef;
TRUNCATE TABLE Population;
TRUNCATE TABLE AlleleFreqBySsPop;
TRUNCATE TABLE SNPSubSNPLink;
TRUNCATE TABLE SNPAlleleFreq;
TRUNCATE TABLE dn_PopulationIndGrp;
"

echo "[INFO] done"
