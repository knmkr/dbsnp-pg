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
          q.snp_id,
          CASE WHEN rscurrent IS NOT NULL THEN rscurrent ELSE q.snp_id END AS snp_current
      FROM
          (SELECT unnest(_rs) AS snp_id) AS q
          LEFT JOIN rsmergearch m ON q.snp_id = m.rshigh
  ),
  info AS (
      SELECT
          f.snp_id,
          max(CASE WHEN rscurrent IS NOT NULL THEN rscurrent ELSE f.snp_id END) AS snp_current,
          array_agg(f.allele) as allele,
          array_agg(f.freq) as freq
      FROM
          allelefreqin1000genomesphase3_b37 f
          LEFT JOIN rsmergearch m ON f.snp_id = m.rshigh
      GROUP BY
          f.snp_id
  )
  SELECT
      query.snp_id,
      info.snp_current,
      info.allele,
      info.freq
  FROM
      query
      LEFT JOIN info ON query.snp_current = info.snp_current
  );
  --
  RETURN;
END
$$ LANGUAGE plpgsql;
