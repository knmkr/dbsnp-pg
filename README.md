# dbsnp-pg

A PostgreSQL porting of [NCBI dbSNP](http://www.ncbi.nlm.nih.gov/SNP/).

## Motivation

Database schema of dbSNP is [distributed in MS SQL Server schema](http://ftp.ncbi.nih.gov/snp/database/shared_schema/), however, [as mentioned in official handbook site](http://www.ncbi.nlm.nih.gov/books/NBK21088/#ch5.ch5_s6), it is not straightforward task to create a local copy of dbSNP:

> How to Create a Local Copy of dbSNP
>
> ...
>
> Due to security concerns and vendor endorsement issues, we cannot provide users with direct dumps of dbSNP. The task of creating a local copy of dbSNP can be complicated, and should be left to an experienced programmer. The following sections will guide you in the process of creating a local copy of dbSNP, but these instructions assume knowledge of relational databases, and were not written with the novice in mind.

So we simply ported schema to PostgreSQL and created dumps of database, thus users can easily build local copy of dbSNP on non-windows platforms.

Moreover, official FTP does not provide SQL queries to get SNP information from database. So we also implemented query functions to get SNP information like in dbSNP website.


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
       3 |         3 |                 |           3
     671 |       671 |                 |         671
 2230021 |           |             671 |         671
```

### Get allele frequency

See details in [contrib/freq](https://github.com/knmkr/dbsnp-pg/tree/master/contrib/freq)

```
=> SELECT * FROM AlleleFreqSource WHERE project = '1000 Genomes Phase 3' AND populations = '{CHB,JPT,CHS}';

 source_id |       project        |  populations  | genome_build | status |          display_name
-----------+----------------------+---------------+--------------+--------+---------------------------------
         4 | 1000 Genomes Phase 3 | {CHB,JPT,CHS} | b37          | ok     | 1000 Genomes Phase3 CHB+JPT+CHS

=> SELECT * FROM get_allele_freq(4, ARRAY[671, 2230021]);

 snp_id  | snp_current | allele |      freq
---------+-------------+--------+-----------------
     671 |         671 | {A,G}  | {0.2168,0.7832}
 2230021 |         671 | {A,G}  | {0.2168,0.7832}
```

### Get GWAS Catalog data

See details in [contrib/gwascatalog](https://github.com/knmkr/dbsnp-pg/tree/master/contrib/gwascatalog)

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


## How to install

E.g.

- dbSNP build: 146
- reference genome build: GRCh37

### 1. Init database

Create a new PostgreSQL user `dbsnp` and database `dbsnp_b146_GRCh37`

    $ createuser dbsnp
    $ createdb --owner=dbsnp dbsnp_b146_GRCh37

### 2. Option A: Download dumps and pg_restore

Download [pg_dump files from Relases pages](https://github.com/knmkr/dbsnp-pg/releases)

    $ wget -c https://github.com/knmkr/dbsnp-pg/releases/download/0.5.6/dbsnp-b146-GRCh37-0.5.6.pg_dump.a{a,b,c,d,e,f,g,h,i}
    $ cat dbsnp-b146-GRCh37-0.5.6.pg_dump.a{a,b,c,d,e,f,g,h,i} > dbsnp.pg_dump

Then restore database

    $ pg_restore -n public -d dbsnp_b146_GRCh37 dbsnp.pg_dump

### 2. Option B: (for developers) Download original data resources and import to database by scripts

    $ ./01_fetch_dbsnp.sh       -d b146 -r GRCh37 $PWD/data
    $ ./02_drop_create_table.sh dbsnp_b146_GRCh37 dbsnp $PWD
    $ ./03_import_data.sh       dbsnp_b146_GRCh37 dbsnp $PWD $PWD/data

This option requires Bash >4.x, `wget`, and `nkf`.


## Requirements

### PostgreSQL version

No limitation. Currently, tested on 9.4.

### Disk usage

Disk usage of whole database is about 58GB (v0.5.6 on Amazon RDS)

```
=> \dti+
                                       List of relations
 Schema |          Name          | Type  | Owner |       Table       |    Size    | Description
--------+------------------------+-------+-------+-------------------+------------+-------------
 public | allele                 | table | dbsnp |                   | 509 MB     |
 public | allele_pkey            | index | dbsnp | allele            | 107 MB     |
 public | contiginfo             | table | dbsnp |                   | 912 kB     |
 public | contiginfo_ukey_ctg    | index | dbsnp | contiginfo        | 136 kB     |
 public | i_rev_allele_id        | index | dbsnp | allele            | 107 MB     |
 public | i_rs                   | index | dbsnp | snp               | 3224 MB    |
 public | i_rsh                  | index | dbsnp | rsmergearch       | 250 MB     |
 public | i_rsl                  | index | dbsnp | rsmergearch       | 250 MB     |
 public | maplink                | table | dbsnp |                   | 7243 MB    |
 public | maplink_snp_id         | index | dbsnp | maplink           | 1291 MB    |
 public | maplinkinfo            | table | dbsnp |                   | 10216 kB   |
 public | maplinkinfo_gi         | index | dbsnp | maplinkinfo       | 2392 kB    |
 public | omimvar_snp_id         | index | dbsnp | omimvarlocusidsnp | 432 kB     |
 public | omimvarlocusidsnp      | table | dbsnp |                   | 1776 kB    |
 public | rsmergearch            | table | dbsnp |                   | 915 MB     |
 public | snp                    | table | dbsnp |                   | 12 GB      |
 public | snp3d                  | table | dbsnp |                   | 184 MB     |
 public | snp3d_snp_id           | index | dbsnp | snp3d             | 19 MB      |
 public | snpchrcode             | table | dbsnp |                   | 8192 bytes |
 public | snpchrcode_ukey_code   | index | dbsnp | snpchrcode        | 16 kB      |
 public | snpchrposonref         | table | dbsnp |                   | 7483 MB    |
 public | snpchrposonref_chr_pos | index | dbsnp | snpchrposonref    | 3233 MB    |
 public | snpchrposonref_ukey_rs | index | dbsnp | snpchrposonref    | 3224 MB    |
 public | snpcontigloc           | table | dbsnp |                   | 15 GB      |
 public | snpcontigloc_rs_ctg    | index | dbsnp | snpcontigloc      | 3317 MB    |
 
=> \l+
                                                                     List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   |   Size    | Tablespace |                Description
-----------+----------+----------+-------------+-------------+-----------------------+-----------+------------+--------------------------------------------
 ebdb      | dbsnp    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 58 GB     | pg_default |
```


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


## Unit Tests

To run tests:

```
$ cd test
$ ./run-test.sh $test_db $test_user
```

Requirements:
  - PostgreSQL extension: [pgTAP (a unit testing framework for PostgreSQL)](http://pgtap.org/)
  - [pg_prove (a command-line tool for running and harnessing pgTAP tests)](http://search.cpan.org/dist/TAP-Parser-SourceHandler-pgTAP/)


## Software License

&copy; 2014 Kensuke Numakura

dbsnp-pg is licensed under the GNU AGPLv3.0. See details in `LICENSE.txt`

![agplv3](https://www.gnu.org/graphics/agplv3-88x31.png)

### OSS Notice

- **termcolor**: Copyright (c) 2008-2011 Volvox Development Team


## Authors

[@knmkr](https://github.com/knmkr)
