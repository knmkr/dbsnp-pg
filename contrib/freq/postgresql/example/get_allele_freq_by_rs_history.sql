SELECT
    *
FROM
    get_tbl_allele_freq_by_rs_history(2, ARRAY[671, 2230021, 4134524, 4986830, 60823674]);

--   snp_id  | snp_current | snp_in_source | allele |      freq
-- ----------+-------------+---------------+--------+-----------------
--       671 |         671 |           671 | {G,A}  | {0.7995,0.2005}
--   2230021 |         671 |           671 | {G,A}  | {0.7995,0.2005}
--   4134524 |         671 |           671 | {G,A}  | {0.7995,0.2005}
--   4986830 |         671 |           671 | {G,A}  | {0.7995,0.2005}
--  60823674 |         671 |           671 | {G,A}  | {0.7995,0.2005}