SELECT
    snp_id, chr, pos, orien AS orien_rs2ref
FROM
    b141_snpchrposonref           -- GRCh38/GRCh37p13
WHERE
    chr = '7' AND pos = 92754573  -- 0-based position

--  snp_id | chr |   pos    | orien_rs2ref
-- --------+-----+----------+--------------
--      10 | 7   | 92754573 | 0
-- (1 row)
