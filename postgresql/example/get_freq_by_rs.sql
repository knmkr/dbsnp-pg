SELECT
    snp_id,
    af.subsnp_id,
    po.loc_pop_id,
    pop2grp.ind_grp_name,
    af."source",
    CASE
        WHEN ss2rs.substrand_reversed_flag = '1' THEN
            (SELECT allele FROM Allele WHERE allele_id = al.rev_allele_id)
        ELSE
            al.allele
        END AS rs_allele,
    freq
FROM
    SNPSubSNPLink ss2rs
    JOIN AlleleFreqBySsPop af USING (subsnp_id)
    LEFT JOIN Population po USING (pop_id)
    LEFT JOIN dn_PopulationIndGrp pop2grp USING (pop_id)
    JOIN Allele al USING (allele_id)
WHERE
    snp_id = 10;
    -- AND pop2grp.ind_grp_name = 'Asian';

--  snp_id | subsnp_id |           loc_pop_id           |    ind_grp_name     | source | rs_allele |   freq
-- --------+-----------+--------------------------------+---------------------+--------+-----------+-----------
--      10 |   4917294 | PDR90                          | Global              | IG     | C         |  0.959302
--      10 |   4917294 | PDR90                          | Global              | IG     | A         | 0.0406977
--      10 |   4917294 | CEPH                           |                     | AF     | C         |      0.96
--      10 |   4917294 | CEPH                           |                     | AF     | A         |      0.04
--      10 |   4917294 | HapMap-CEU                     | European            | IG     | C         |  0.966667
--      10 |   4917294 | HapMap-CEU                     | European            | IG     | A         | 0.0333333
--      10 |   4917294 | HapMap-HCB                     | Asian               | IG     | C         |         1
--      10 |   4917294 | HapMap-JPT                     | Asian               | IG     | C         |         1
--      10 |   4917294 | HapMap-YRI                     | Sub-Saharan African | IG     | C         |         1
--      10 |  23499092 | AFD_EUR_PANEL                  | European            | IG     | A         | 0.0208333
--      10 |  23499092 | AFD_EUR_PANEL                  | European            | IG     | C         |  0.979167
--      10 |  23499092 | AFD_AFR_PANEL                  | African American    | IG     | A         | 0.0217391
--      10 |  23499092 | AFD_AFR_PANEL                  | African American    | IG     | C         |  0.978261
--      10 |  23499092 | AFD_CHN_PANEL                  | Asian               | IG     | C         |         1
--      10 |  66862334 | HSP_GENO_PANEL                 |                     | IG     | C         |     0.975
--      10 |  66862334 | HSP_GENO_PANEL                 |                     | IG     | A         |     0.025
--      10 |  66862334 | CEU_GENO_PANEL                 | European            | IG     | C         |  0.966667
--      10 |  66862334 | CEU_GENO_PANEL                 | European            | IG     | A         | 0.0333333
--      10 |  66862334 | AAM_GENO_PANEL                 | African American    | IG     | C         |         1
--      10 |  66862334 | CHB_GENO_PANEL                 | Asian               | IG     | C         |         1
--      10 |  66862334 | YRI_GENO_PANEL                 | Sub-Saharan African | IG     | C         |         1
--      10 |  66862334 | JPT_GENO_PANEL                 | Asian               | IG     | C         |         1
--      10 |  98170163 | J. Craig Venter                |                     | IG     | C         |         1
--      10 | 116196150 | YRI                            |                     | IG     | C         |         1
--      10 | 142685511 | ENSEMBL_Watson                 |                     | IG     | C         |         1
--      10 | 144170965 | ENSEMBL_Venter                 |                     | IG     | C         |         1
--      10 | 162531813 | CEU                            | European            | IG     | C         |         1
--      10 | 164850583 | YRI                            | Sub-Saharan African | IG     | C         |         1
--      10 | 166862840 | PGP                            |                     | IG     | C         |         1
--      10 | 197913087 | BUSHMAN_POP                    |                     | IG     | C         |         1
--      10 | 197913087 | BUSHMAN_POP2                   |                     | IG     | C         |         1
--      10 | 197913087 | BANTU                          |                     | IG     | C         |         1
--      10 | 234076633 | pilot_1_CEU_low_coverage_panel |                     | AF     | A         |      0.05
--      10 | 234076633 | pilot_1_CEU_low_coverage_panel |                     | AF     | C         |      0.95
-- (34 rows)
