#!/usr/bin/env bash

database="human_9606"  # or `human_9606_b141_GRCh37p13`, etc.
dbsnp="141"

echo "[INFO] Fetching data..."
# shared
wget ftp.ncbi.nih.gov/snp/database/shared_data/Allele.bcp.gz

# rs
wget ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/RsMergeArch.bcp.gz

# allele freq by ss
wget ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/Population.bcp.gz
wget ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/AlleleFreqBySsPop.bcp.gz
wget ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/dn_PopulationIndGrp.bcp.gz

# ss <-> rs
wget ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPSubSNPLink.bcp.gz

# position on reference genome
wget ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/b${dbsnp}_SNPChrPosOnRef.bcp.gz

# optional
# wget ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz
# wget ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPAlleleFreq.bcp.gz

echo "[INFO] Done"
