UPDATE tmp_rs2current SET rsCurrent = tmpMapping.rsCurrent, orien2Current = tmpMapping.orien2Current FROM (
SELECT
    tmp_rs2current.rshigh,
    CASE WHEN bump.rscurrent IS NOT NULL THEN bump.rscurrent ELSE tmp_rs2current.rshigh END AS rscurrent,
    CASE WHEN bump.orien2current IS NOT NULL THEN bump.orien2current ELSE B'0' END AS orien2current
FROM
    tmp_rs2current
    LEFT OUTER JOIN (
        SELECT
            rshigh, rscurrent, orien2current
        FROM
            rsmergearch
        WHERE rshigh in (SELECT rshigh FROM tmp_rs2current)
        ) bump ON tmp_rs2current.rshigh = bump.rshigh
    ) tmpMapping
WHERE
    tmp_rs2current.rshigh = tmpMapping.rshigh;
