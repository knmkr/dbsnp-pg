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
  SELECT INTO ret chr, pos + 1 FROM b141_snpchrposonref_grch37p13 WHERE snp_id = _rs;
  RETURN ret;
END
$$ LANGUAGE plpgsql;
