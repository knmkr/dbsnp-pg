DROP FUNCTION IF EXISTS get_tbl_allele_freq_by_rs_history(
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT ref varchar[],
  OUT alt varchar[],
  OUT freq real[]
);

CREATE OR REPLACE FUNCTION get_tbl_allele_freq_by_rs_history(
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT ref varchar[],
  OUT alt varchar[],
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
  freq AS (
      SELECT
          f.snp_id,
          CASE WHEN rscurrent IS NOT NULL THEN rscurrent ELSE f.snp_id END AS snp_current,
          f.ref,
          f.alt,
          freq_eas -- FIXME
      FROM
          allelefreqin1000genomesphase3_b37 f
          LEFT JOIN rsmergearch m ON f.snp_id = m.rshigh
  )
  SELECT
      query.snp_id,
      f.snp_current,
      f.ref,
      f.alt,
      freq_eas
  FROM
      query
      LEFT JOIN freq f ON query.snp_current = f.snp_current
  );
  --
  RETURN;
END
$$ LANGUAGE plpgsql;
