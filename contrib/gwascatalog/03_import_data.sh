#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing data..."

TODAY=$(date +"%Y-%m-%d")
cd ${DATA_DIR}/${TODAY}

# Use pypy if available
if type pypy >/dev/null; then
  py=$(which pypy)
else
  py=$(which python)
fi

table=GwasCatalog
tmp_table=GwasCatalog_`python -c "import uuid; print str(uuid.uuid4()).replace('-','')"`

filename=gwascatalog-downloaded-${TODAY}.tsv
echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ${filename} into ${table} ..."

${py} ${BASE_DIR}/script/cleanup.py ${filename} \
    | nkf -Lu \
    | psql $PG_DB $PG_USER -c "CREATE TEMP TABLE ${tmp_table}
                               ON COMMIT DROP
                               AS SELECT * FROM ${table}
                               WITH NO DATA;

                               COPY ${tmp_table} FROM stdin DELIMITERS '	' WITH NULL AS '';

                               -- Ignore duplicate records
                               INSERT INTO ${table}
                               SELECT DISTINCT ON (date_downloaded, pubmed_id, disease_or_trait, snp_id_current, risk_allele) * FROM ${tmp_table}
                               " -q

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Updating snp_id_current ..."
psql $PG_DB $PG_USER -c "UPDATE ${table}
                         SET snp_id_current = a.rscurrent
                         FROM (SELECT rshigh, rscurrent FROM rsmergearch) a
                         WHERE ${table}.snp_id_reported = a.rshigh"

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Creating GwasCatalogSNPAlleleFreq ..."
freq_tsv=gwascatalog-snps-allele-freq-${TODAY}.tsv
${BASE_DIR}/script/create_gwascatalog_snp_allele_freq_data.sh $PG_DB $PG_USER ${freq_tsv}
cat ${freq_tsv}| psql $PG_DB $PG_USER -c "COPY GwasCatalogSNPAlleleFreq FROM stdin DELIMITERS '	' WITH NULL AS ''" -q

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
