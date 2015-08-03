BEGIN;
SELECT * FROM plan(6);

SELECT set_eq(
  'SELECT snp_id, array_agg(ref) as ref, array_agg(alt) as alt, array_agg(freq_eas) as eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 367896724 GROUP BY snp_id',
  $$ VALUES
  (367896724,'{A}'::varchar[],'{AC}'::varchar[],'{0.3363}'::real[])
  $$
);

SELECT set_eq(
  'SELECT snp_id, array_agg(ref) as ref, array_agg(alt) as alt, array_agg(freq_eas) as eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 1 GROUP BY snp_id',
  $$ VALUES
  (1,'{G,G}'::varchar[],'{A,C}'::varchar[],'{0.2,0.5}'::real[])
  $$
);
SELECT set_eq(
  'SELECT snp_id, array_agg(ref) as ref, array_agg(alt) as alt, array_agg(freq_eas) as eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 2 GROUP BY snp_id',
  $$ VALUES
  (2,'{G}'::varchar[],'{T}'::varchar[],'{0.3}'::real[])
  $$
);
SELECT set_eq(
  'SELECT snp_id, array_agg(ref) as ref, array_agg(alt) as alt, array_agg(freq_eas) as eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 3 GROUP BY snp_id',
  $$ VALUES
  (3,'{G,G}'::varchar[],'{A,T}'::varchar[],'{0.1,0.2}'::real[])
  $$
);
SELECT set_eq(
  'SELECT snp_id, array_agg(ref) as ref, array_agg(alt) as alt, array_agg(freq_eas) as eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 4 GROUP BY snp_id',
  $$ VALUES
  (4,'{G,G}'::varchar[],'{GC,GCC}'::varchar[],'{0.3,0.4}'::real[])
  $$
);
SELECT set_eq(
  'SELECT snp_id, array_agg(ref) as ref, array_agg(alt) as alt, array_agg(freq_eas) as eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 5 GROUP BY snp_id',
  $$ VALUES
  (5,'{G}'::varchar[],'{GAA}'::varchar[],'{0.1}'::real[])
  $$
);

SELECT * FROM finish();
ROLLBACK;
