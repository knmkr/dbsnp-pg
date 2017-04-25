--
CREATE OR REPLACE FUNCTION get_allele_freq(
  _source_id int,
  _rs int[],
  OUT snp_id int,
  OUT snp_current int,
  OUT "ref" varchar,
  OUT allele varchar[],
  OUT freq real[],
  OUT freqx integer[]
) RETURNS SETOF RECORD AS $$
BEGIN
  RETURN QUERY (
      SELECT
          DISTINCT
          a.snp_id,
          a.snp_current,
          f.ref,
          f.allele,
          f.freq,
          f.freqx
      FROM
          get_current_rs(_rs) a
          LEFT OUTER JOIN (SELECT af.snp_id, af.ref, af.allele, af.freq, af.freqx FROM allelefreq af WHERE source_id = _source_id) f ON a.snp_current = f.snp_id  -- f.snp_id have been updated to current while bulk importing
  );
END
$$ LANGUAGE plpgsql;
