#!/usr/bin/env bash

DATA_DIR=$1

mkdir -p ${DATA_DIR}
cd ${DATA_DIR}

echo "[contrib/freq] [INFO] Fetching data..."

# 1000 genomes phase1
mkdir -p 1000genomes.phase1
cd 1000genomes.phase1
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20110521/ALL.chr{{1..22},X}.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz
cd ..

# 1000 genomes phase3
mkdir -p 1000genomes.phase3
cd 1000genomes.phase3
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr{1..22}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr{1..22}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz.tbi
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf{.gz,.gz.tbi}
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrY.phase3_integrated_v2a.20130502.genotypes.vcf{.gz,.gz.tbi}
cd ..

# # HapMap
# wget -c ftp://ftp.ncbi.nlm.nih.gov/hapmap/phasing/2009-02_phaseIII/HapMap3_r2/JPT+CHB/hapmap3_r2_b36_fwd.consensus.qc.poly.chr{1..22}_jpt+chb.unr.phased.gz

echo "[contrib/freq] [INFO] Done"
