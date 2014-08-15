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


## Lisence

See LISENCE


## Author

@knmkr
