DROP FUNCTION IF EXISTS get_tbl_allele_freq_by_rs_history(
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT allele varchar[],
  OUT freq real[]
);

CREATE OR REPLACE FUNCTION get_tbl_allele_freq_by_rs_history(
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT allele varchar[],
  OUT freq real[]
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
  --
  WITH query AS (
      SELECT
          arg.snp_id,
          CASE WHEN rscurrent IS NOT NULL THEN rscurrent ELSE arg.snp_id END AS snp_current,
          rshigh,
          rslow
      FROM
          (SELECT unnest(_rs) AS snp_id) AS arg
          LEFT JOIN rsmergearch m ON arg.snp_id = m.rshigh
  ),
  -- NOTE: To avoid Seq Scan on `rsmergearch`, split CTE as `info` and `info_with_snp_current`
  info AS (
      SELECT
          f.snp_id,
          array_agg(f.allele) as allele,
          array_agg(f.freq) as freq
      FROM
          allelefreqin1000genomesphase3_b37 f
      WHERE
          f.snp_id IN (
              SELECT q.snp_id FROM query q
              UNION SELECT q.snp_current FROM query q
              UNION SELECT q.rshigh FROM query q
              UNION SELECT q.rslow FROM query q
          )
      GROUP BY
          f.snp_id
  ),
  info_with_snp_current AS (
      SELECT
          i.snp_id,
          CASE WHEN rscurrent IS NOT NULL THEN rscurrent ELSE i.snp_id END AS snp_current,
          i.allele,
          i.freq
      FROM
          info i
          LEFT JOIN rsmergearch m ON i.snp_id = m.rshigh
  )
  SELECT q.snp_id, q.snp_current, i.allele, i.freq FROM query q LEFT JOIN info_with_snp_current i USING (snp_current)
  --
  );
END
$$ LANGUAGE plpgsql;
