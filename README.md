# dbsnp-pg-min

[dbsnp-pg-min](https://github.com/knmkr/dbsnp-pg-min) is a minimal PostgreSQL schemas & functions for Human data in [NCBI dbSNP](http://www.ncbi.nlm.nih.gov/SNP/).

- NCBI dbSNP (a public archive for genetic variation) is distributed in MS SQL Server schema.
- We simply port minimal original MS SQL Server schema to PostgreSQL,
- and implemented query functions to get [SNP information like in dbSNP web CGI](http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=671) in command line interface.

[![Build Status](https://travis-ci.org/knmkr/dbsnp-pg-min.svg?branch=master)](https://travis-ci.org/knmkr/dbsnp-pg-min)

## Getting Started

    # 0. Create new PostgreSQL database for dbSNP
    $ createdb --owner=username dbsnp_b141

    # 1. Fetch dbSNP data from dbSNP FTP site
    $ ./01_fetch_data.sh $PWD/data

    # 2. Create PostgreSQL tables for dbSNP
    $ ./02_drop_create_table.sh dbsnp_b141 username $PWD

    # 3. Import dbSNP data into PostgreSQL tables,
    #    and add constraints (index, etc.) to tables
    $ ./03_import_data.sh dbsnp_b141 username $PWD $PWD/data


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
- Build versions of dbSNP and human references genome assemblies are:

| database name             | dbSNP    | reference genome |
|---------------------------|----------|------------------|
| human_9606_b144_GRCh38p2  | b144     | GRCh38p2         |
| human_9606_b144_GRCh37p13 | b144     | GRCh37p13        |
| human_9606_b142_GRCh38    | b142     | GRCh38           |
| human_9606_b142_GRCh37p13 | b142     | GRCh37p13        |

To specify the versions, use `-d` and `-r` options in `01_fetch_dbsnp.sh`:

```
$ ./01_fetch_dbsnp.sh -d b141 -r GRCh37p13
```


## Requirements

- PostgreSQL (>9.3 is preferred)
- Bash >4.x


## License

See `LICENSE.txt`


## Author

[@knmkr](https://github.com/knmkr)
