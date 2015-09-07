BEGIN;
SELECT * FROM plan(3);

-- 1000 genomes phase1 CHB+JPT
SELECT set_eq(
  'SELECT snp_id,snp_current,snp_in_source,allele,freq::text FROM get_tbl_allele_freq_by_rs_history(1, ARRAY[671,26])',
  $$ VALUES
  (671,      671,      671, '{G,A}'::varchar[], '{0.8145,0.1855}'),
  (26,        26, 78384355, '{C,T}'::varchar[], '{0.6774,0.3226}')
  $$
);

-- 1000 genomes phase3 CHB+JPT
SELECT set_eq(
  'SELECT snp_id,snp_current,allele,freq::text FROM get_tbl_allele_freq_by_rs_history(2, ARRAY[671, 2230021, 4134524, 4986830, 60823674])',
  $$ VALUES
  (671,      671, '{G,A}'::varchar[], '{0.7995,0.2005}'),
  (2230021,  671, '{G,A}'::varchar[], '{0.7995,0.2005}'),
  (4134524,  671, '{G,A}'::varchar[], '{0.7995,0.2005}'),
  (4986830,  671, '{G,A}'::varchar[], '{0.7995,0.2005}'),
  (60823674, 671, '{G,A}'::varchar[], '{0.7995,0.2005}')
  $$
);

-- FIXME: update test/data/.vcf to all sample ids. (currently only CHB+JPT+)
-- 1000 genomes phase3 CEU
-- SELECT set_eq(
--   'SELECT snp_id,snp_current,allele,freq::text FROM get_tbl_allele_freq_by_rs_history(4, ARRAY[671])',
--   $$ VALUES
--   (671,      671, '{G,A}'::varchar[], '{0.8145,0.1855}')
--   $$
-- );

SELECT * FROM finish();
ROLLBACK;
