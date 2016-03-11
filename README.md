# dbsnp-pg-min

[dbsnp-pg-min](https://github.com/knmkr/dbsnp-pg-min) is a minimal PostgreSQL schemas for Human data in [NCBI dbSNP](http://www.ncbi.nlm.nih.gov/SNP/).

- NCBI dbSNP is [distributed in MS SQL Server schema](http://ftp.ncbi.nih.gov/snp/database/shared_schema/).
- We simply ported original schema to PostgreSQL, and implemented query functions to get [SNP information like in dbSNP web CGI](http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=671).


## Getting Started

Create new PostgreSQL database for dbSNP:

    $ createdb --owner=username dbsnp_b144_GRCh37

Then fetch data, create table, and import data:

    $ ./01_fetch_dbsnp.sh       -d b144 -r GRCh37 $PWD/data
    $ ./02_drop_create_table.sh dbsnp_b144_GRCh37 username $PWD
    $ ./03_import_data.sh       dbsnp_b144_GRCh37 username $PWD $PWD/data

Or pg_restore from [pg_dump files (listed in the release page)](https://github.com/knmkr/dbsnp-pg-min/releases):

    $ pg_restore -d dbsnp_b144_GRCh37 ${pg_dump}

## Usage example

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


## Unit Tests

To run tests:

```
$ cd test
$ ./run-test.sh $test_db $test_user
```

Requirements:
  - PostgreSQL extension: [pgTAP (a unit testing framework for PostgreSQL)](http://pgtap.org/)
  - [pg_prove (a command-line tool for running and harnessing pgTAP tests)](http://search.cpan.org/dist/TAP-Parser-SourceHandler-pgTAP/)


## Notes

- Only human [taxonomy id: 9606] data is supported.
- dbSNP builds and human references genome builds are depend on the releases on the NCBI FTP:

| dbSNP    | Reference Genome |
|----------|------------------|
| b146     | GRCh38p2         |
| b146     | GRCh37p13        |
| b144     | GRCh38p2         |
| b144     | GRCh37p13        |


## Requirements

- PostgreSQL (>9.3 is preferred)
- Bash >4.x


## License

See `LICENSE.txt`


## Author

[@knmkr](https://github.com/knmkr)
