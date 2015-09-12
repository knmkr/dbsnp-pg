# contrib/gwascatalog

- Integrate *NHGRI-EBI GWAS Catalog* with dbSNP


## Usage example

```
SELECT pubmed_id, disease_or_trait, snp_id, risk_allele, odds_ratio_or_beta_coeff
FROM gwascatalog
WHERE snp_id = 671
AND risk_allele IS NOT NULL;

 pubmed_id |             disease_or_trait              | snp_id | risk_allele | odds_ratio_or_beta_coeff
-----------+-------------------------------------------+--------+-------------+--------------------------
  19698717 | Esophageal cancer                         |    671 | A           |                     1.67
  20139978 | Hematological and biochemical traits      |    671 | A           |                     0.12
  20139978 | Mean corpuscular hemoglobin concentration |    671 | A           |                     0.08
  21971053 | Coronary heart disease                    |    671 | A           |                     1.43
  22286173 | Intracranial aneurysm                     |    671 | C           |                     1.24
  22797727 | Renal function-related traits (sCR)       |    671 | A           |                        0
  24861553 | Body mass index                           |    671 | G           |                     0.04
```


## Notes

- Supporting new [GWAS Catalog hosted on EMBL-EBI](http://www.ebi.ac.uk/gwas), which used to be hosted on [NHGRI](https://www.genome.gov/26525384)

### References

- *NHGRI-EBI GWAS Catalog data*

> Burdett T (EBI), Hall PN (NHGRI), Hasting E (EBI) Hindorff LA (NHGRI), Junkins HA (NHGRI), Klemm AK (NHGRI), MacArthur J (EBI), Manolio TA (NHGRI), Morales J (EBI), Parkinson H (EBI) and Welter D (EBI).
> The NHGRI-EBI Catalog of published genome-wide association studies.
> Available at: www.ebi.ac.uk/gwas. Accessed [date of access], version [version number].
> version number only applies to the download spreadsheet - v1.0 for the traditional version of the spreadsheet, v1.0.1 for the version with added EFO terms


### TODOs

- Fetch dbSNP and reference genome build versions from [web documentations](http://www.ebi.ac.uk/gwas/docs/fileheaders).
