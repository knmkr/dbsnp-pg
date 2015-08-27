# contrib/freq

- Allele frequencies based on the 1000 Genomes genotype data.


## Usage example

```
=> SELECT * FROM get_tbl_allele_freq_by_rs_history(ARRAY[671, 2230021, 4134524, 4986830, 60823674]);

  snp_id  | snp_current | allele |        freq
----------+-------------+--------+---------------------
      671 |         671 | {G,A}  | {0.799517,0.200483}
  2230021 |         671 | {G,A}  | {0.799517,0.200483}
  4134524 |         671 | {G,A}  | {0.799517,0.200483}
  4986830 |         671 | {G,A}  | {0.799517,0.200483}
 60823674 |         671 | {G,A}  | {0.799517,0.200483}
```


## Notes

### Source files

`ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/`

See datails in `01_fetch_data.sh`


### Population groups

Currently only `CHB+JPT` is available.

```
$ wc -l script/sample_ids.*
213 script/sample_ids.1000genomes.CHB+JPT.txt
```


### TODOs

- [ ] Add European and African population.
- [ ] Add HapMap
