-- SQL Example:
-- Getting allele freqs for given rs# and population groups. rs# will be converted to current rs#.

-- Mapping of rs# to current rs#
CREATE TEMPORARY TABLE rs2current (
       rsHigh            integer        primary key,
       rsCurrent         integer,
       orien2Current     integer  -- TODO: bit
);
                                                    -- ss2rs rs2chr
INSERT INTO rs2current (rshigh) VALUES (57659014);  -- 0     0
INSERT INTO rs2current (rshigh) VALUES (57659074);  -- 0     1
INSERT INTO rs2current (rshigh) VALUES (57659148);  -- 1     1
INSERT INTO rs2current (rshigh) VALUES (57659150);  --       0  TODO: handling null values
-- TODO:                                               0     1

UPDATE rs2current SET rsCurrent = tmpMapping.rsCurrent, orien2Current = tmpMapping.orien2Current FROM (
SELECT
    rs2current.rshigh,
    CASE WHEN bump.rscurrent IS NOT NULL THEN bump.rscurrent ELSE rs2current.rshigh END AS rscurrent,
    CASE WHEN bump.orien2current IS NOT NULL THEN bump.orien2current ELSE 0 END AS orien2current  -- TODO: bit
FROM
    rs2current
    LEFT OUTER JOIN (
        SELECT
            rshigh, rscurrent, orien2current
        FROM
            rsmergearch
        WHERE rshigh in (SELECT rshigh FROM rs2current)
        ) bump ON rs2current.rshigh = bump.rshigh
    ) tmpMapping
WHERE
    rs2current.rshigh = tmpMapping.rshigh;
SELECT * FROM rs2current;

--   rshigh  | rscurrent | orien2current
-- ----------+-----------+---------------
--  57659014 |  12042114 |             0
--  57659074 |    340338 |             1
--  57659148 |   1540515 |             1
--  57659150 |  57659150 |             0
-- (4 rows)


-- Getting allele freqs for current rs#
SELECT
    rshigh, rscurrent, subsnp_id, ss_allele, substrand_reversed_flag, rs2current.orien2current, allele, loc_pop_id, source, freq
FROM
    rs2current
    LEFT OUTER JOIN (
        SELECT
            snp_id,
            af.subsnp_id,
            al.allele AS ss_allele,
            substrand_reversed_flag,
            rs2current.orien2current,
            CASE
              WHEN ss2rs.substrand_reversed_flag # rs2current.orien2current::bit = B'1' THEN  -- TODO: bit
                  (SELECT allele FROM Allele WHERE allele_id = al.rev_allele_id)
              ELSE
                  al.allele
              END AS allele,
            po.loc_pop_id,
            source,
            freq
        FROM
            SNPSubSNPLink ss2rs
            JOIN rs2current ON rs2current.rscurrent = snp_id
            JOIN AlleleFreqBySsPop af ON af.subsnp_id = ss2rs.subsnp_id
            JOIN Population po ON af.pop_id = po.pop_id
            JOIN Allele al ON af.allele_id = al.allele_id
            JOIN dn_PopulationIndGrp pop2grp ON af.pop_id = pop2grp.pop_id
        WHERE
            snp_id = ANY(ARRAY(SELECT rscurrent FROM rs2current))
            AND pop2grp.ind_grp_name = 'Asian'
    ) freqs ON rs2current.rscurrent = freqs.snp_id
;

--   rshigh  | rscurrent | subsnp_id | ss_allele | substrand_reversed_flag | orien2current | allele |  loc_pop_id   | source |   freq
-- ----------+-----------+-----------+-----------+-------------------------+---------------+--------+---------------+--------+----------
--  57659014 |  12042114 |  23200215 | C         | 0                       |             0 | C      | AFD_CHN_PANEL | IG     |  0.26087
--  57659014 |  12042114 |  23200215 | T         | 0                       |             0 | T      | AFD_CHN_PANEL | IG     |  0.73913
--  57659074 |    340338 |   2908537 | C         | 0                       |             1 | G      | HapMap-JPT    | IG     |        1
--  57659074 |    340338 |   2908537 | C         | 0                       |             1 | G      | HapMap-HCB    | IG     |        1
--  57659148 |   1540515 |  23712154 | C         | 1                       |             1 | C      | AFD_CHN_PANEL | IG     | 0.645833
--  57659148 |   1540515 |  23712154 | T         | 1                       |             1 | T      | AFD_CHN_PANEL | IG     | 0.354167
--  57659150 |  57659150 |           |           |                         |             0 |        |               |        |
-- (7 rows)
