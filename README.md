# dbsnp-pg

A PostgreSQL porting of [NCBI dbSNP](http://www.ncbi.nlm.nih.gov/SNP/).

[NCBI dbSNP is distributed in MS SQL Server schema](http://ftp.ncbi.nih.gov/snp/database/shared_schema/). We simply ported original schema to PostgreSQL, and implemented query functions to get SNP information like in dbSNP website.


## How to use

### Get chrom and position

```
=> SELECT * FROM get_pos_by_rs(ARRAY[3,671]);

 snp_id  | snp_current | chr |    pos
---------+-------------+-----+-----------
       3 |           3 | 13  |  32446842
     671 |         671 | 12  | 112241766
```

### Get current rs ID

```
=> SELECT * FROM get_current_rs(ARRAY[1,2,3,671,2230021]);

 snp_id  | snp_valid | snp_merged_into | snp_current
---------+-----------+-----------------+-------------
       1 |           |                 |
       2 |           |                 |
       3 |         3 |                 |           3
     671 |       671 |                 |         671
 2230021 |           |             671 |         671
```

### Get allele frequency

```
=> SELECT * FROM get_allele_freq(3, ARRAY[671, 2230021]);

 snp_id  | snp_current | allele |      freq
---------+-------------+--------+-----------------
     671 |         671 | {A,G}  | {0.2168,0.7832}
 2230021 |         671 | {A,G}  | {0.2168,0.7832}
```

See details in `contrib/freq`

### Get GWAS Catalog data

```
=> SELECT pubmed_id, disease_or_trait, snp_id, risk_allele, odds_ratio_or_beta_coeff
FROM gwascatalog
WHERE snp_id = 671
AND risk_allele IS NOT NULL;

 pubmed_id |             disease_or_trait              | snp_id | risk_allele | odds_ratio_or_beta_coeff
-----------+-------------------------------------------+--------+-------------+--------------------------
  19698717 | Esophageal cancer                         |    671 | A           |                     1.67
  20139978 | Hematological and biochemical traits      |    671 | A           |                     0.12
  20139978 | Mean corpuscular hemoglobin concentration |    671 | A           |                     0.08
  21971053 | Coronary heart disease                    |    671 | A           |                     1.43
  22286173 | Intracranial aneurysm                     |    671 | C           |                     1.24
  22797727 | Renal function-related traits (sCR)       |    671 | A           |                        0
  24861553 | Body mass index                           |    671 | G           |                     0.04
```

See details in `contrib/gwascatalog`


## How to install

E.g.

- dbSNP build: 146
- reference genome build: GRCh37

Create a new PostgreSQL user `dbsnp` and database `dbsnp_b146_GRCh37`

    $ createuser dbsnp
    $ createdb --owner=dbsnp dbsnp_b146_GRCh37

### A. Build from resources

Then fetch data, create table, and import data:

    $ ./01_fetch_dbsnp.sh       -d b146 -r GRCh37 $PWD/data
    $ ./02_drop_create_table.sh dbsnp_b146_GRCh37 dbsnp $PWD
    $ ./03_import_data.sh       dbsnp_b146_GRCh37 dbsnp $PWD $PWD/data

### B. Restore from pg_dump

Or pg_restore from [pg_dump files (listed in the release page)](https://github.com/knmkr/dbsnp-pg/releases):

    $ wget -c https://github.com/knmkr/dbsnp-pg/releases/download/0.5.5/dbsnp-b146-GRCh37-0.5.5.pg_dump.a{a,b,c,d,e,f,g}
    $ cat dbsnp-b146-GRCh37-0.5.5.pg_dump.a{a,b,c,d,e,f,g} > dbsnp.pg_dump
    $ pg_restore -n public -d dbsnp_b146_GRCh37 dbsnp.pg_dump


## Software Requirements

- PostgreSQL (>9.3 is preferred)
- Bash >4.x
- wget, nkf


## Unit Tests

To run tests:

```
$ cd test
$ ./run-test.sh $test_db $test_user
```

Requirements:
  - PostgreSQL extension: [pgTAP (a unit testing framework for PostgreSQL)](http://pgtap.org/)
  - [pg_prove (a command-line tool for running and harnessing pgTAP tests)](http://search.cpan.org/dist/TAP-Parser-SourceHandler-pgTAP/)


## Data Resources

- **Database of Single Nucleotide Polymorphisms (dbSNP).** Bethesda (MD): National Center for Biotechnology Information, National Library of Medicine. (dbSNP Build ID: b144,146,147).
Available from: http://www.ncbi.nlm.nih.gov/SNP/

| dbSNP    | Reference Genome |
|----------|------------------|
| b147     | GRCh38p2         |
| b147     | GRCh37p13        |
| b146     | GRCh38p2         |
| b146     | GRCh37p13        |
| b144     | GRCh38p2         |
| b144     | GRCh37p13        |

- Only human [taxonomy id: 9606] data is supported.
- Builds of dbSNP and human references genome are depend on the releases on the NCBI FTP.


## Software Licenses

See `LICENSE.txt`

- **dbsnp-pg**: Copyright (c) 2014,2015,2016 Kensuke Numakura
- **termcolor**: Copyright (c) 2008-2011 Volvox Development Team


## Authors

[@knmkr](https://github.com/knmkr)
