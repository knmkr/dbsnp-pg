SELECT
    rshigh,rscurrent,orien2current
FROM
    rsmergearch
WHERE rshigh = ANY(ARRAY[330, 331, 332]);
