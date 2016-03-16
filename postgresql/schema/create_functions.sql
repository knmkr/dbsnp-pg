--
-- => SELECT * FROM get_current_rs(ARRAY[1,2,3,671,2230021]);
--  snp_id  | snp_valid | snp_merged_into | snp_current
-- ---------+-----------+-----------------+-------------
--        1 |           |                 |
--        2 |           |                 |
--        3 |         3 |                 |           3
--      671 |       671 |                 |         671
--  2230021 |           |             671 |         671
--
CREATE OR REPLACE FUNCTION get_current_rs(
  _rs int[],
  OUT snp_id int,
  OUT snp_valid int,
  OUT snp_merged_into int,
  OUT snp_current int
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
      SELECT
          a.snp_id,
          snp.snp_id AS snp_valid,
          m.rscurrent AS snp_merged_into,
          CASE WHEN snp.snp_id IS NOT NULL THEN snp.snp_id
               WHEN m.rscurrent IS NOT NULL THEN m.rscurrent END AS snp_current
      FROM
          (SELECT unnest(_rs) as snp_id) a
          LEFT JOIN snp ON a.snp_id = snp.snp_id
          LEFT JOIN rsmergearch m ON a.snp_id = m.rshigh
  );
END
$$ LANGUAGE plpgsql;

--
CREATE OR REPLACE FUNCTION get_pos_by_rs(
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT chr varchar,
  OUT pos int
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
      SELECT
          a.snp_id,
          a.snp_current,
          p.chr,
          p.pos + 1  -- 0-based to 1-based
      FROM
          get_current_rs(_rs) a
          LEFT JOIN snpchrposonref p ON a.snp_current = p.snp_id
  );
  RETURN;
END
$$ LANGUAGE plpgsql;

--
CREATE OR REPLACE FUNCTION get_rs_by_pos(_chr varchar, _pos int)
RETURNS int[] AS $$
BEGIN
  --
  RETURN (SELECT array_agg(snp_id) FROM snpchrposonref WHERE chr = _chr AND pos = _pos - 1);  -- 1-based to 0-based
END
$$ LANGUAGE plpgsql;

--
CREATE OR REPLACE FUNCTION get_all_pos_by_rs(
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT chr varchar,
  OUT pos int
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
      SELECT
          a.snp_id,
          a.snp_current,
          ctg.contig_chr AS chr,
          loc.phys_pos_from + 1 AS pos  -- 0-based to 1-based
      FROM
          get_current_rs(_rs) a
          LEFT JOIN (SELECT l.snp_id, l.ctg_id, l.phys_pos_from FROM snpcontigloc l WHERE l.snp_type = 'rs') loc ON a.snp_current = loc.snp_id
          LEFT JOIN contiginfo ctg USING (ctg_id)
  );
  RETURN;
END
$$ LANGUAGE plpgsql;
