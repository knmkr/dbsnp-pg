-- Only for PostgreSQL version 9.3 or later
--
-- - Dependencies
--   - `json` type
--   - `json_agg()` function

DROP FUNCTION IF EXISTS get_json_freq_by_rs(_rs int);
CREATE OR REPLACE FUNCTION get_json_freq_by_rs(_rs int)
RETURNS json AS $$
BEGIN
  --
  RETURN (SELECT json_agg(f.*) FROM get_tbl_freq_by_rs(_rs) f);
END
$$ LANGUAGE plpgsql;
