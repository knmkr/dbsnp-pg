#!/usr/bin/env bash

DATA_DIR=$1

mkdir -p ${DATA_DIR}
cd ${DATA_DIR}

echo "[contrib/freq] [INFO] Fetching data..."

# 1000 genomes phase1
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20110521/ALL.chr{{1..22},X}.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz

# 1000 genomes phase3
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr{1..22}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrY.phase3_integrated_v1b.20130502.genotypes.vcf.gz

echo "[contrib/freq] [INFO] Done"
