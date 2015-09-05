-- Partitioning
CREATE OR REPLACE FUNCTION allelefreq_insert_trigger()
RETURNS TRIGGER AS $$
    BEGIN
        IF ( NEW.source_id = 1 ) THEN
            INSERT INTO allelefreq_1 VALUES (NEW.*);
        ELSIF ( NEW.source_id = 2 ) THEN
            INSERT INTO allelefreq_2 VALUES (NEW.*);
        ELSE
            RAISE EXCEPTION 'Invalid source_id in allelefreq_insert_trigger()';
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_alllefreq_trigger
    BEFORE INSERT ON allelefreq
    FOR EACH ROW EXECUTE PROCEDURE allelefreq_insert_trigger();

--
DROP FUNCTION IF EXISTS get_tbl_allele_freq_by_rs_history(
  _source_id int,
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT snp_in_source int,
  OUT allele varchar[],
  OUT freq real[]
);

CREATE OR REPLACE FUNCTION get_tbl_allele_freq_by_rs_history(
  _source_id int,
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT snp_in_source int,
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
              allelefreq f
          WHERE
              f.source_id = _source_id
              AND f.snp_id IN (
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
      arg.snp_id, arg.snp_current, i.snp_id, i.allele, i.freq
  FROM
      arg LEFT JOIN info_with_snp_current i USING (snp_current)
  );
END
$$ LANGUAGE plpgsql;
