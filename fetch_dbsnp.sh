#!/usr/bin/env bash

echo "[INFO] Fetching data..."
# shared
wget ftp.ncbi.nih.gov:/snp/database/shared_data/Allele.bcp.gz

# rs
wget ftp.ncbi.nih.gov/snp/organisms/human_9606/database/organism_data/RsMergeArch.bcp.gz
wget ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/database/organism_data/b141_SNPChrPosOnRef.bcp.gz

# ss <-> rs
wget ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/organism_data/SNPSubSNPLink.bcp.gz

# allele freq by ss
wget ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/organism_data/AlleleFreqBySsPop.bcp.gz
wget ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/organism_data/Population.bcp.gz


echo "[INFO] Done"
