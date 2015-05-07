SELECT
    rshigh,rscurrent,orien2current
FROM
    rsmergearch
WHERE rshigh = ANY(ARRAY[330, 331, 332]);

--  rshigh | rscurrent | orien2current
-- --------+-----------+---------------
--     332 | 121909001 |             0
-- (1 row)
