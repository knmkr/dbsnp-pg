# dbsnp-pg-min

Minimal PostgreSQL schemes/functions for Human [9606] data in [NCBI dbSNP](http://www.ncbi.nlm.nih.gov/SNP/).

- NCBI dbSNP (a public archive for genetic variation) is distributed in MS SQL Server scheme.
- We simply port original database scheme to PostgreSQL,
- and implemented query functions to get [SNP information like in dbSNP web CGI](http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=671) in command line interface.


## Getting Started

    $ createdb --owner=username dbsnp_b141           # 0. Create new PostgreSQL database for dbSNP
    $ ./01_fetch_dbsnp.sh                            # 1. Fetch dbSNP data from dbSNP FTP site
    $ ./02_drop_create_table.sh dbsnp_b141 username  # 2. Create PostgreSQL tables for dbSNP
    $ ./03_import_dbsnp.sh      dbsnp_b141 username  # 3. Import dbSNP data into PostgreSQL tables
    $ ./04_add_constraints.sh   dbsnp_b141 username  # 4. Add constraints (index, etc.) to tables


## Dependency

- PostgreSQL >8.4
- nkf   # TODO
- wget  # TODO


## SQL example

### Allele freqs for given rs\# and population groups :

rs# = 10, population = Asian

    $ psql dbsnp_b141 username -c "
    SELECT
        snp_id,
        af.subsnp_id,
        po.loc_pop_id,
        source,
        al.allele AS ss_allele,
        CASE
          WHEN ss2rs.substrand_reversed_flag = '1' THEN
                  (SELECT allele FROM Allele WHERE allele_id = al.rev_allele_id)
          ELSE
                  al.allele
          END AS rs_allele_id,
        freq
    FROM
        SNPSubSNPLink ss2rs
        JOIN AlleleFreqBySsPop af ON af.subsnp_id = ss2rs.subsnp_id
        JOIN Population po ON af.pop_id = po.pop_id
        JOIN Allele al ON af.allele_id = al.allele_id
        JOIN dn_PopulationIndGrp pop2grp ON af.pop_id = pop2grp.pop_id
    WHERE
        snp_id = 10
        AND pop2grp.ind_grp_name = 'Asian';
    "
     snp_id | subsnp_id | loc_pop_id | source | ss_allele | rs_allele_id |   freq
    --------+-----------+------------+--------+-----------+--------------+-----------
         10 |   4917294 | HapMap-HCB | IG     | G         | C            |         1
         10 |   4917294 | HapMap-JPT | IG     | G         | C            |         1
    (2 rows)

### Current rs\# for given rs\# :

    $ psql dbsnp_b141 username -c "
    SELECT
        rshigh,rscurrent
    FROM
        rsmergearch
    WHERE rshigh = ANY(ARRAY[330, 331, 332]);
    "
     rshigh | rscurrent
    --------+-----------
        332 | 121909001
    (1 row)

or simply

    $ psql dbsnp_b141 username -c "SELECT get_current_rs(332);"
    121909001


## Unit Tests

- Requirements
  - PostgreSQL extension: [pgTAP (a unit testing framework for PostgreSQL)](http://pgtap.org/)
  - [pg_prove (a command-line tool for running and harnessing pgTAP tests)](http://search.cpan.org/dist/TAP-Parser-SourceHandler-pgTAP/)

To run tests:

```
$ cd test
$ ./test.sh
```


## Notes

- Only human [9606] data is supported.
- Build versions of dbSNP and human reference genome assembly are:

| database name             | dbSNP    | reference genome |
|---------------------------+----------+------------------|
| human_9606                | (latest) | (latest)         |
| human_9606_b142_GRCh38    | b142     | GRCh38           |
| human_9606_b142_GRCh37p13 | b142     | GRCh37p13        |
| human_9606_b141_GRCh38    | b141     | GRCh38           |
| human_9606_b141_GRCh37p13 | b141     | GRCh37p13        |


## Lisence

See LISENCE


## Author

@knmkr
