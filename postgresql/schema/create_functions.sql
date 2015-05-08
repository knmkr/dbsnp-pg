DROP FUNCTION IF EXISTS get_current_rs(_rs int);
CREATE OR REPLACE FUNCTION get_current_rs(_rs int)
RETURNS int AS $$
BEGIN
  --
  RETURN (SELECT rscurrent FROM rsmergearch WHERE rshigh = _rs);
END
$$ LANGUAGE plpgsql;

-- FIXME: dependency on `b141_snpchrposonref_grch37p13`
DROP FUNCTION IF EXISTS get_pos_by_rs(_rs int);
CREATE OR REPLACE FUNCTION get_pos_by_rs(_rs int)
RETURNS record AS $$
DECLARE
  ret record;
BEGIN
  --
  SELECT INTO ret chr, pos + 1 FROM b141_snpchrposonref_grch37p13 WHERE snp_id = _rs;  -- 0-based to 1-based
  RETURN ret;
END
$$ LANGUAGE plpgsql;

-- FIXME: dependency on `b141_snpchrposonref_grch37p13`
DROP FUNCTION IF EXISTS get_rs_by_pos(_chr varchar, _pos int);
CREATE OR REPLACE FUNCTION get_rs_by_pos(_chr varchar, _pos int)
RETURNS int[] AS $$
BEGIN
  --
  RETURN (SELECT array_agg(snp_id) FROM b141_snpchrposonref_grch37p13 WHERE chr = _chr AND pos = _pos - 1);  -- 1-based to 0-based
END
$$ LANGUAGE plpgsql;

--
DROP FUNCTION IF EXISTS get_tbl_freq_by_rs(
  _rs int,
  OUT snp_id int,
  OUT subsnp_id int,
  OUT loc_pop_id varchar,
  OUT ind_grp_name varchar,
  OUT "source" varchar,
  OUT rs_allele varchar,
  OUT freq real
);
CREATE OR REPLACE FUNCTION get_tbl_freq_by_rs(
  _rs int,
  OUT snp_id int,
  OUT subsnp_id int,
  OUT loc_pop_id varchar,
  OUT ind_grp_name varchar,
  OUT "source" varchar,
  OUT rs_allele varchar,
  OUT freq real
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
  SELECT
    ss2rs.snp_id,
    af.subsnp_id,
    po.loc_pop_id,
    pop2grp.ind_grp_name,
    af."source",
    CASE
      WHEN ss2rs.substrand_reversed_flag = '1' THEN
        (SELECT allele FROM Allele WHERE allele_id = al.rev_allele_id)
      ELSE
        al.allele
      END AS rs_allele,
    af.freq
  FROM
    SNPSubSNPLink ss2rs
    JOIN AlleleFreqBySsPop af USING (subsnp_id)
    LEFT JOIN Population po USING (pop_id)
    LEFT JOIN dn_PopulationIndGrp pop2grp USING (pop_id)
    JOIN Allele al USING (allele_id)
  WHERE
    ss2rs.snp_id = _rs
  ORDER BY
    (ss2rs.snp_id, af.subsnp_id, po.loc_pop_id)
  );
  RETURN;
END
$$ LANGUAGE plpgsql;
