DROP FUNCTION IF EXISTS get_current_rs(_rs int);
CREATE OR REPLACE FUNCTION get_current_rs(_rs int)
RETURNS int AS $$
BEGIN
  --
  RETURN (SELECT rscurrent FROM rsmergearch WHERE rshigh = _rs);
END
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS get_pos_by_rs(_rs int);
CREATE OR REPLACE FUNCTION get_pos_by_rs(_rs int)
RETURNS record AS $$
DECLARE
  ret record;
BEGIN
  --
  SELECT INTO ret chr, pos + 1 FROM snpchrposonref WHERE snp_id = _rs;  -- 0-based to 1-based
  RETURN ret;
END
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS get_rs_by_pos(_chr varchar, _pos int);
CREATE OR REPLACE FUNCTION get_rs_by_pos(_chr varchar, _pos int)
RETURNS int[] AS $$
BEGIN
  --
  RETURN (SELECT array_agg(snp_id) FROM snpchrposonref WHERE chr = _chr AND pos = _pos - 1);  -- 1-based to 0-based
END
$$ LANGUAGE plpgsql;
