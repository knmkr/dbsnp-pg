# contrib/freq

- Allele frequencies based on public genotype data.


## How to use

```
=> SELECT * FROM AlleleFreqSource WHERE status = 'ok';
 source_id |       project        |  populations  | genome_build | status |          display_name
-----------+----------------------+---------------+--------------+--------+---------------------------------
         4 | 1000 Genomes Phase 3 | {CHB,JPT,CHS} | b37          | ok     | 1000 Genomes Phase3 CHB+JPT+CHS
       100 | 1000 Genomes Phase 3 | {CEU}         | b37          | ok     | 1000 Genomes Phase3 CEU
       200 | 1000 Genomes Phase 3 | {YRI}         | b37          | ok     | 1000 Genomes Phase3 YRI
       300 | 1000 Genomes Phase 3 | {Global}      | b37          | ok     | 1000 Genomes Phase3 Global

=> SELECT * FROM get_tbl_allele_freq_by_rs_history(4, ARRAY[671, 2230021]);
  snp_id  | snp_current | snp_in_source | allele |      freq
----------+-------------+---------------+--------+-----------------
      671 |         671 |           671 | {G,A}  | {0.7995,0.2005}
  2230021 |         671 |           671 | {G,A}  | {0.7995,0.2005}
```


## Data Reources

| project             | populations              |
|---------------------|--------------------------|
| ~~1000 Genomes Phase1~~ | ~~East Asian (CHB+JPT)~~     |
| 1000 Genomes Phase3 | East Asian (CHB+JPT)     |
| 1000 Genomes Phase3 | European (CEU)           |
| 1000 Genomes Phase3 | African (YRI)            |

- Samples with patternal/matternal sample (father/mathor) in the same projects are excluded.

See datails in `01_fetch_data.sh` and `03_import_data.sh`


## Software Requirements

- [PLINK](http://pngu.mgh.harvard.edu/~purcell/plink/)
