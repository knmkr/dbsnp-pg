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

### Get allele freqs for ss#

    $ psql dbsnp_b141 username -c "
    SELECT subsnp_id, po.loc_pop_id, al.allele, source, freq
    FROM AlleleFreqBySsPop af
         join Population po on af.pop_id = po.pop_id
         join Allele al on af.allele_id = al.allele_id
    WHERE subsnp_id = 241441355
    LIMIT 5
    "
     subsnp_id |             loc_pop_id             | allele | source |   freq
    -----------+------------------------------------+--------+--------+----------
     241441355 | pilot_1_CHB+JPT_low_coverage_panel | G      | AF     | 0.383333
     241441355 | pilot_1_CHB+JPT_low_coverage_panel | T      | AF     | 0.616667
    (2 rows)

### Get allele freqs for rs#

    $ psql dbsnp_b141 username -c "
    SELECT
        snp_id,
        af.subsnp_id,
        po.loc_pop_id,
        al.allele AS ss_allele,
        CASE WHEN ss2rs.substrand_reversed_flag = 0 THEN al.allele ELSE al.rev_allele END AS rs_allele
        source,
        freq
    FROM
        SNPSubSNPLink ss2rs
        JOIN AlleleFreqBySsPop af ON af.subsnp_id = ss2rs.subsnp_id
        JOIN Population po ON af.pop_id = po.pop_id
        JOIN Allele al ON af.allele_id = al.allele_id
    WHERE
        snp_id = 6983267
    LIMIT
        5;
    "


## Lisence

See LISENCE


## Author

@knmkr
