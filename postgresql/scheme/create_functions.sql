DROP FUNCTION IF EXISTS get_current_rs(_query_rs int);
CREATE FUNCTION get_current_rs(_query_rs int)
RETURNS int AS $$
BEGIN

  RETURN (SELECT rscurrent FROM rsmergearch WHERE rshigh = _query_rs);

END
$$ LANGUAGE plpgsql;
