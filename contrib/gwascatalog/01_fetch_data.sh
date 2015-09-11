#!/usr/bin/env bash

DATA_DIR=$1

mkdir -p ${DATA_DIR}
cd ${DATA_DIR}

echo "[contrib/gwascatalog] [INFO] Fetching data..."

# NHGRI-EBI GWAS Catalog
wget -c http://www.ebi.ac.uk/gwas/api/search/downloads/full -O gwas_catalog-downloaded_$(date +"%Y-%m-%d").tsv

echo "[contrib/gwascatalog] [INFO] Done"
