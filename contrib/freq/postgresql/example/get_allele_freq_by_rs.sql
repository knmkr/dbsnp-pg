SELECT
    *
FROM
    allelefreq
WHERE
    source_id = 2
    AND snp_id = 671;

--  snp_id | chr |    pos    | allele |  freq  | source_id
-- --------+-----+-----------+--------+--------+-----------
--     671 | 12  | 112241766 | G      | 0.7995 |         2
--     671 | 12  | 112241766 | A      | 0.2005 |         2
