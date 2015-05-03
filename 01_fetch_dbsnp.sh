#!/usr/bin/env bash

# # GRCh38
# database="human_9606"
# ref=""
# dbsnp="141"

# GRCh37p13
database="human_9606_b141_GRCh37p13"
ref="_GRCh37p13"
dbsnp="141"

mkdir -p data
cd data

echo "[INFO] Fetching data..."
# shared
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/Allele.bcp.gz  # 63.1 MB

# rs
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/RsMergeArch.bcp.gz  # 131 MB

# allele freq by ss
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/Population.bcp.gz  # 148 kB
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/AlleleFreqBySsPop.bcp.gz  # 1.1 GB
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/dn_PopulationIndGrp.bcp.gz  # 550 B

# ss <-> rs
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPSubSNPLink.bcp.gz  # 1.8 GB

# position on reference genome
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/b${dbsnp}_SNPChrPosOnRef${ref}.bcp.gz  # 481 MB

# optional
# wget -c ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz  # 767 B
# wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPAlleleFreq.bcp.gz  # 483 MB

echo "[INFO] Done"
