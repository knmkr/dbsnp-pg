# contrib/freq

- Allele frequencies based on the 1000 genomes phase 3.


## Usage example

```
=> SELECT snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 62636497;

  snp_id  | ref |  alt  |    freq_eas
----------+-----+-------+-----------------
 62636497 | A   | {G,T} | {0.4812,0.5188}
```


## Notes

### Source files

`ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5a.20130502.sites.vcf.gz` (1.8G)

```
##reference=ftp://ftp.1000genomes.ebi.ac.uk//vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
```

```
##INFO=<ID=EAS_AF,Number=A,Type=Float,Description="Allele frequency in the EAS populations calculated from AC and AN, in the range (0,1)">
##INFO=<ID=EUR_AF,Number=A,Type=Float,Description="Allele frequency in the EUR populations calculated from AC and AN, in the range (0,1)">
##INFO=<ID=AFR_AF,Number=A,Type=Float,Description="Allele frequency in the AFR populations calculated from AC and AN, in the range (0,1)">
##INFO=<ID=AMR_AF,Number=A,Type=Float,Description="Allele frequency in the AMR populations calculated from AC and AN, in the range (0,1)">
##INFO=<ID=SAS_AF,Number=A,Type=Float,Description="Allele frequency in the SAS populations calculated from AC and AN, in the range (0,1)">
```

```
#CHROM         POS            ID             REF            ALT            QUAL           FILTER         INFO
1              10177          rs367896724    A              AC             100            PASS           AC=2130;AF=0.425319;AN=5008;NS=2504;DP=103152;EAS_AF=0.3363;AMR_AF=0.3602;AFR_AF=0.4909;EUR_AF=0.4056;SAS_AF=0.4949;AA=|||unknown(NO_COVERAGE);VT=INDEL
```


### Population groups

`ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/README_vcf_info_annotation.20141104`

```
2. Allele frequency by continental super population

The 2504 samples in the phase3 release are from 26 populations which can be categorised into five super-populations
by continent (listed below).  As well as the global AF in the INFO field. We added AF for each super-population to the INFO field.

East Asian      EAS
South Asian     SAS
African         AFR
European        EUR
American        AMR
```
