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
          i.snp_id,
          array_agg(i.allele) as allele,
          array_agg(i.freq) as freq
      FROM (
          SELECT
              f.snp_id,
              f.allele,
              f.freq
          FROM
              allelefreqin1000genomesphase3_b37 f
          WHERE
              f.snp_id IN (
                  SELECT q.snp_id FROM query q
                  UNION SELECT q.snp_current FROM query q
                  UNION SELECT q.rshigh FROM query q
                  UNION SELECT q.rslow FROM query q
              )
          ORDER BY
              f.snp_id ASC, f.freq DESC
      ) i
      GROUP BY
          i.snp_id
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


-- WIP
-- FIXME
DROP FUNCTION IF EXISTS get_tbl_allele_freq_by_rs_history_1000genomes_phase1(
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT allele varchar[],
  OUT freq real[]
);

CREATE OR REPLACE FUNCTION get_tbl_allele_freq_by_rs_history_1000genomes_phase1(
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT allele varchar[],
  OUT freq real[]
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
  --
  WITH arg AS (
      SELECT
          a.snp_id,
          CASE WHEN rscurrent IS NOT NULL THEN rscurrent ELSE a.snp_id END AS snp_current
      FROM
          (SELECT unnest(_rs) AS snp_id) AS a
          LEFT JOIN rsmergearch m ON a.snp_id = m.rshigh
  ),
  query AS (
      SELECT
          m.rscurrent, m.rshigh, m.rslow
      FROM
          rsmergearch m
      WHERE
          rshigh = ANY(_rs)
          OR rslow = ANY(_rs)
          OR rscurrent = ANY(_rs)
      UNION
          SELECT unnest(_rs), NULL, NULL
  ),
  -- NOTE: To avoid Seq Scan on `rsmergearch`, split CTE as `info` and `info_with_snp_current`
  info AS (
      SELECT
          i.snp_id,
          array_agg(i.allele) as allele,
          array_agg(i.freq) as freq
      FROM (
          SELECT
              f.snp_id,
              f.allele,
              f.freq
          FROM
              allelefreqin1000genomesphase1_b37 f
          WHERE
              f.snp_id IN (
                  SELECT q.rscurrent FROM query q
                  UNION SELECT q.rshigh FROM query q
                  UNION SELECT q.rslow FROM query q
              )
          ORDER BY
              f.snp_id ASC, f.freq DESC
      ) i
      GROUP BY
          i.snp_id
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
  SELECT
      arg.snp_id, arg.snp_current, i.allele, i.freq
  FROM
      arg LEFT JOIN info_with_snp_current i USING (snp_current)
  );
END
$$ LANGUAGE plpgsql;

-- WIP
-- FIXME
CREATE OR REPLACE FUNCTION get_tbl_snp_id_in_1000genomes_phase1(
  _rs int[],
  OUT snp_id int,
  OUT snp_id_in_source int
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
  --
  WITH arg AS (
      SELECT
          a.snp_id,
          CASE WHEN rscurrent IS NOT NULL THEN rscurrent ELSE a.snp_id END AS snp_current
      FROM
          (SELECT unnest(_rs) AS snp_id) AS a
          LEFT JOIN rsmergearch m ON a.snp_id = m.rshigh
  ),
  query AS (
      SELECT
          m.rscurrent, m.rshigh, m.rslow
      FROM
          rsmergearch m
      WHERE
          rshigh = ANY(_rs)
          OR rslow = ANY(_rs)
          OR rscurrent = ANY(_rs)
      UNION
          SELECT unnest(_rs), NULL, NULL
  ),
  -- NOTE: To avoid Seq Scan on `rsmergearch`, split CTE as `info` and `info_with_snp_current`
  info AS (
      SELECT
          i.snp_id,
          array_agg(i.allele) as allele,
          array_agg(i.freq) as freq
      FROM (
          SELECT
              f.snp_id,
              f.allele,
              f.freq
          FROM
              allelefreqin1000genomesphase1_b37 f
          WHERE
              f.snp_id IN (
                  SELECT q.rscurrent FROM query q
                  UNION SELECT q.rshigh FROM query q
                  UNION SELECT q.rslow FROM query q
              )
          ORDER BY
              f.snp_id ASC, f.freq DESC
      ) i
      GROUP BY
          i.snp_id
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
  SELECT
      arg.snp_id, i.snp_id
  FROM
      arg LEFT JOIN info_with_snp_current i USING (snp_current)
  );
END
$$ LANGUAGE plpgsql;
