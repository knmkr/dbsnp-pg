SELECT
    snp_id, chr, pos, orien AS orien_rs2ref
FROM
    b141_snpchrposonref
WHERE
    snp_id = 333333;

--  snp_id | chr |    pos    | orien_rs2ref
-- --------+-----+-----------+--------------
--  333333 | 3   | 124609540 | 0
-- (1 row)
