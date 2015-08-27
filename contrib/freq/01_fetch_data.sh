#!/usr/bin/env bash

DATA_DIR=$1

mkdir -p ${DATA_DIR}
cd ${DATA_DIR}

echo "[contrib/freq] [INFO] Fetching data..."

# GRCh37
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr{1..22}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrY.phase3_integrated_v1b.20130502.genotypes.vcf.gz

# TODO: GRCh38

echo "[contrib/freq] [INFO] Done"
