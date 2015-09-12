#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing data..."

cd ${DATA_DIR}

# Use pypy if available
if type pypy >/dev/null; then
  py=$(which pypy)
else
  py=$(which python)
fi

table=GwasCatalog
tmp_table=GwasCatalog_`python -c "import uuid; print str(uuid.uuid4()).replace('-','')"`

for filename in gwas*.tsv; do
    echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ${filename} into ${table} ..."

    ${py} ${BASE_DIR}/script/cleanup.py ${filename}| \
        psql $PG_DB $PG_USER -c "
            CREATE TEMP TABLE ${tmp_table}
            ON COMMIT DROP
            AS SELECT * FROM ${table}
            WITH NO DATA;

            COPY ${tmp_table} FROM stdin DELIMITERS '	' WITH NULL AS '';

            -- Ignore duplicate records
            INSERT INTO ${table}
            SELECT DISTINCT ON (date_downloaded, pubmed_id, disease_or_trait, snp_id, risk_allele) * FROM ${tmp_table}
            " -q
done

echo "[contrib/gwascatalog] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
