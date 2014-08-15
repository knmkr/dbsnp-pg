#!/usr/bin/env bash

echo "[INFO] Fetching data..."
wget ftp.ncbi.nih.gov/snp/organisms/human_9606/database/organism_data/RsMergeArch.bcp.gz
wget ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/database/organism_data/b141_SNPChrPosOnRef.bcp.gz

echo "[INFO] Done"
