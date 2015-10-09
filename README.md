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

    $ pg_restore -d dbsnp_b142_GRCh37 ${pg_dump}

## Usage example

### Get chrom and position for given rs\#.

```
SELECT get_pos_by_rs(333333);
(3,124609540)
```

### Get current rs\# for given rs\#.

```
SELECT get_current_rs(332);
121909001
```

### Get allele frequency for given rs\#.

```
SELECT * FROM get_tbl_allele_freq_by_rs_history(2, ARRAY[671, 2230021]);
  snp_id  | snp_current | snp_in_source | allele |      freq
----------+-------------+---------------+--------+-----------------
      671 |         671 |           671 | {G,A}  | {0.7995,0.2005}
  2230021 |         671 |           671 | {G,A}  | {0.7995,0.2005}
```

See details in `contrib/freq`

### Get GWAS Catalog data for given rs\#.

```
SELECT pubmed_id, disease_or_trait, snp_id, risk_allele, odds_ratio_or_beta_coeff
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

- Only human [9606] data is supported.
- Build versions of dbSNP and references genome assemblies depend on the versions in NCBI FTP release:

| PostgreSQL database name  | dbSNP    | reference genome |
|---------------------------|----------|------------------|
| dbsnp_b144_GRCh38         | b144     | GRCh38p2         |
| dbsnp_b144_GRCh37         | b144     | GRCh37p13        |
| dbsnp_b142_GRCh38         | b142     | GRCh38           |
| dbsnp_b142_GRCh37         | b142     | GRCh37p13        |


## Requirements

- PostgreSQL (>9.3 is preferred)
- Bash >4.x


## License

See `LICENSE.txt`


## Author

[@knmkr](https://github.com/knmkr)
