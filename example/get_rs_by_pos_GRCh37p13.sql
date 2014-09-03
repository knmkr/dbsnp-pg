SELECT
    snp_id, chr, pos, orien AS orien_rs2ref
FROM
    b141_snpchrposonref           -- GRCh37p13
WHERE
    chr = '7' AND pos = 92383887  -- 0-based position
