SELECT
    rshigh, tmp_rs2current.rscurrent, ss_allele, substrand_reversed_flag, orien_rs2ref, allele, loc_pop_id, source, freq
FROM
    tmp_rs2current
    LEFT OUTER JOIN (
        SELECT
            rscurrent,
            al.allele AS ss_allele,
            substrand_reversed_flag,
            pos.orien AS orien_rs2ref,
            CASE
              WHEN ss2rs.substrand_reversed_flag # pos.orien = B'1' THEN  -- TODO: bit
                  (SELECT allele FROM Allele WHERE allele_id = al.rev_allele_id)
              ELSE
                  al.allele
              END AS allele,
            po.loc_pop_id,
            source,
            freq
        FROM
            SNPSubSNPLink ss2rs
            JOIN tmp_rs2current ON tmp_rs2current.rscurrent = snp_id
            JOIN AlleleFreqBySsPop af ON af.subsnp_id = ss2rs.subsnp_id
            JOIN Population po ON af.pop_id = po.pop_id
            JOIN Allele al ON af.allele_id = al.allele_id
            JOIN dn_PopulationIndGrp pop2grp ON af.pop_id = pop2grp.pop_id
            JOIN b141_snpchrposonref pos ON pos.snp_id = rscurrent
        WHERE
            ss2rs.snp_id = ANY(ARRAY(SELECT rscurrent FROM tmp_rs2current))
            AND pop2grp.ind_grp_name = 'Asian'

            -- HapMap
            AND loc_pop_id = 'HapMap-JPT'  -- HapMap JPT (100? individuals)
            -- AND loc_pop_id = 'HapMap-HCB'  -- HapMap HCB (180? individuals)
            -- AND loc_pop_id like '%HapMap%'

            -- 1000GENOMES
            -- AND loc_pop_id = 'pilot_1_CHB+JPT_low_coverage_panel'  -- 1000GENOMES JPT+CHB (60? individuals)

    ) freqs ON tmp_rs2current.rscurrent = freqs.rscurrent
;

--   rshigh  | rscurrent | ss_allele | substrand_reversed_flag | orien_rs2ref | allele | loc_pop_id | source | freq
-- ----------+-----------+-----------+-------------------------+--------------+--------+------------+--------+------
--  57659014 |  12042114 |           |                         |              |        |            |        |
--  57659074 |    340338 | C         | 0                       | 1            | G      | HapMap-JPT | IG     |    1
--  57659148 |   1540515 |           |                         |              |        |            |        |
--  57659150 |  57659150 |           |                         |              |        |            |        |
-- (4 rows)
