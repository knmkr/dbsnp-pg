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
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/Allele.bcp.gz{,.md5}  # 63.1 MB

# rs
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/RsMergeArch.bcp.gz{,.md5}  # 131 MB

# allele freq by ss
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/Population.bcp.gz{,.md5}  # 148 kB
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/AlleleFreqBySsPop.bcp.gz{,.md5}  # 1.1 GB
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/dn_PopulationIndGrp.bcp.gz{,.md5}  # 550 B

# ss <-> rs
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPSubSNPLink.bcp.gz{,.md5}  # 1.8 GB

# position on reference genome
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/b${dbsnp}_SNPChrPosOnRef${ref}.bcp.gz{,.md5}  # 481 MB

# optional
# wget -c ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz{,.md5}  # 767 B
# wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPAlleleFreq.bcp.gz{,.md5}  # 483 MB

echo "[INFO] Checking md5..."

type openssl >/dev/null 2>&1; is_openssl_cmd_found=$?
type md5sum >/dev/null 2>&1; is_md5sum_cmd_found=$?

for src in *.gz; do
  if [ $is_openssl_cmd_found = 0 ]; then
     diff <(openssl md5 ${src}) <(cat ${src}.md5)
  elif [ $is_md5sum_cmd_found = 0 ]; then
     md5sum -c ${src}.md5
  else
    echo "[WARN] Command `openssl` or `md5sum` not found. Skipping md5 check."
    break
  fi
done

echo "[INFO] Done"
