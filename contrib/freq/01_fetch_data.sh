#!/usr/bin/env bash

DATA_DIR=$1

mkdir -p ${DATA_DIR}
cd ${DATA_DIR}

echo "[contrib/freq] [INFO] Fetching data..."

wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5a.20130502.sites.vcf.gz  # 1.8 GB

echo "[contrib/freq] [INFO] Done"
