# contrib/freq

- Allele frequencies based on public genotype data.


## How to use

```
=> SELECT * FROM AlleleFreqSource;
 source_id |      project         |  populations  | genome_build
-----------+----------------------+---------------+--------------
         4 | 1000 Genomes Phase 3 | {CHB,JPT,CHS} | b37
...

=> SELECT * FROM get_tbl_allele_freq_by_rs_history(2, ARRAY[671, 2230021, 4134524, 4986830, 60823674]);
  snp_id  | snp_current | snp_in_source | allele |      freq
----------+-------------+---------------+--------+-----------------
      671 |         671 |           671 | {G,A}  | {0.7995,0.2005}
  2230021 |         671 |           671 | {G,A}  | {0.7995,0.2005}
  4134524 |         671 |           671 | {G,A}  | {0.7995,0.2005}
  4986830 |         671 |           671 | {G,A}  | {0.7995,0.2005}
 60823674 |         671 |           671 | {G,A}  | {0.7995,0.2005}
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
