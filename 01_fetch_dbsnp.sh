#!/usr/bin/env bash

# GRCh38
database="human_9606"
ref=""
dbsnp="141"

# GRCh37p13
# database="human_9606_b141_GRCh37p13"
# ref="_GRCh37p13"
# dbsnp="141"

echo "[INFO] Fetching data..."
# shared
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/Allele.bcp.gz

# rs
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/RsMergeArch.bcp.gz

# allele freq by ss
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/Population.bcp.gz
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/AlleleFreqBySsPop.bcp.gz
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/dn_PopulationIndGrp.bcp.gz

# ss <-> rs
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPSubSNPLink.bcp.gz

# position on reference genome
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/b${dbsnp}_SNPChrPosOnRef${ref}.bcp.gz

# optional
# wget -c ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz
# wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPAlleleFreq.bcp.gz

echo "[INFO] Done"
