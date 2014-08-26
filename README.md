# dbsnp-pg-min

Minimal PostgreSQL schemes for dbSNP. (dbSNP is written in MS SQL Server)


## Getting Started

    $ # Create PostgreSQL database for dbSNP
    $ createdb --owner=username dbsnp_b141

    $ # Create PostgreSQL table for dbSNP
    $ psql dbsnp_b141 username -f drop_create_table.sql

    $ # Fetch original dbSNP data from dbSNP FTP site
    $ ./fetch_dbsnp.sh

    $ # Import dbSNP data
    $ ./import_dbsnp.sh dbsnp_b141 username


## Dependency

- PostgreSQL
- nkf (TODO)
- wget (TODO)


## SQL example

### Allele freqs for given rs\# :

    $ psql dbsnp_b141 username -c "
    SELECT
        snp_id,
        af.subsnp_id,
        po.loc_pop_id,
        source,
        al.allele AS ss_allele,
        CASE
          WHEN ss2rs.substrand_reversed_flag = '0' THEN
                  al.allele
          ELSE
                  (SELECT allele FROM Allele WHERE allele_id = al.rev_allele_id)
          END AS rs_allele_id,
        freq
    FROM
        SNPSubSNPLink ss2rs
        JOIN AlleleFreqBySsPop af ON af.subsnp_id = ss2rs.subsnp_id
        JOIN Population po ON af.pop_id = po.pop_id
        JOIN Allele al ON af.allele_id = al.allele_id
    WHERE
        snp_id = 10;
    "
     snp_id | subsnp_id | loc_pop_id | source | ss_allele | rs_allele_id |   freq
    --------+-----------+------------+--------+-----------+--------------+-----------
         10 |   4917294 | PDR90      | IG     | G         | C            |  0.959302
         10 |   4917294 | PDR90      | IG     | T         | A            | 0.0406977
         10 |   4917294 | CEPH       | AF     | G         | C            |      0.96
         10 |   4917294 | CEPH       | AF     | T         | A            |      0.04
         10 |   4917294 | HapMap-CEU | IG     | G         | C            |  0.966667
         10 |   4917294 | HapMap-CEU | IG     | T         | A            | 0.0333333
         10 |   4917294 | HapMap-HCB | IG     | G         | C            |         1
         10 |   4917294 | HapMap-JPT | IG     | G         | C            |         1
         10 |   4917294 | HapMap-YRI | IG     | G         | C            |         1
    (9 rows)

### Current rs\# for given rs\# :

    $ psql dbsnp_b141 username -c "
    SELECT
        rshigh,rscurrent,orien2current
    FROM
        rsmergearch
    WHERE rshigh = ANY(ARRAY[330, 331, 332]);
    "
     rshigh | rscurrent | orien2current
    --------+-----------+---------------
        332 | 121909001 |             0
    (1 row)


## Lisence

See LISENCE


## Author

@knmkr
