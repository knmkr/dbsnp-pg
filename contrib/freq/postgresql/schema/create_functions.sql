--
CREATE OR REPLACE FUNCTION get_tbl_allele_freq_by_rs_history(
  _source_id int,
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT allele varchar[],
  OUT freq real[]
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
      SELECT
          a.snp_id,
          a.snp_current,
          f.allele,
          f.freq
      FROM
          get_tbl_current_rs(_rs) a
          LEFT OUTER JOIN allelefreq f ON a.snp_current = f.snp_id  -- f.snp_id have been updated to current while bulk importing
      WHERE
          source_id = _source_id
          OR source_id IS NULL  -- TODO:
  );
END
$$ LANGUAGE plpgsql;
