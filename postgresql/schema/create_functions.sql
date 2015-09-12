DROP FUNCTION IF EXISTS get_current_rs(_rs int);
CREATE OR REPLACE FUNCTION get_current_rs(_rs int)
RETURNS int AS $$
DECLARE
  snp_current int;
BEGIN
  --
  SELECT INTO snp_current rscurrent FROM rsmergearch WHERE rshigh = _rs;
  IF snp_current IS NULL THEN
      RETURN _rs;
  ELSE
      RETURN snp_current;
  END IF;
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

CREATE OR REPLACE FUNCTION get_tbl_pos_by_rs(
  _rs int,
  OUT chr varchar(32),
  OUT pos int
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
      SELECT s.chr, s.pos + 1 FROM snpchrposonref s WHERE snp_id = _rs  -- 0-based to 1-based
  );
  RETURN;
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
