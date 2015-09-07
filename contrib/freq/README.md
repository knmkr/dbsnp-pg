# contrib/freq

- Allele frequencies based on the 1000 Genomes genotype data.


## Usage example

```
=> SELECT * FROM AlleleFreqSource;
 source_id |      project       |  populations  | genome_build
-----------+--------------------+---------------+--------------
         1 | 1000genomes_phase1 | {CHB,JPT,CHS} | b37
         2 | 1000genomes_phase3 | {CHB,JPT,CHS} | b37
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


## Notes

### Source files

`ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/`

See datails in `01_fetch_data.sh`


### Population groups

Currently only `CHB+JPT+CHS` is available.


### TODOs

- [ ] Add European and African population.
- [ ] Add HapMap
