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

### Get allele freqs for rs#

    $ psql dbsnp_b141 username -c "
    SELECT
        ss2rs.snp_id,
        af.subsnp_id,
        po.loc_pop_id,
        al.allele AS ss_allele,
        CASE WHEN ss2rs.substrand_reversed_flag = 0 THEN al.allele ELSE al.rev_allele END AS rs_allele
        CASE WHEN ss2rs.substrand_reversed_flag # rs.orien = 0 THEN al.allele ELSE al.rev_allele END AS chr_allele
        source,
        freq
    FROM
        SNPSubSNPLink ss2rs
        JOIN AlleleFreqBySsPop af ON af.subsnp_id = ss2rs.subsnp_id
        JOIN Population po ON af.pop_id = po.pop_id
        JOIN Allele al ON af.allele_id = al.allele_id
        JOIN b141_SNPChrPosOnRef rs ON ss2rs.snp_id = rs.snp_id
    WHERE
        snp_id = 6983267
    LIMIT
        5;
    "


## Lisence

See LISENCE


## Author

@knmkr
