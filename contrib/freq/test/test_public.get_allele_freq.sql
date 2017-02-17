BEGIN;
SELECT * FROM plan(1);

-- 1000 genomes phase3 CHB+JPT+CHS
SELECT set_eq(
  'SELECT snp_id, snp_current, allele, freq::text FROM get_allele_freq(4, ARRAY[671, 2230021, 4134524, 4986830, 60823674])',
  $$ VALUES
  (671,      671, '{A,G}'::varchar[], '{0.2244,0.7756}'),
  (2230021,  671, '{A,G}'::varchar[], '{0.2244,0.7756}'),
  (4134524,  671, '{A,G}'::varchar[], '{0.2244,0.7756}'),
  (4986830,  671, '{A,G}'::varchar[], '{0.2244,0.7756}'),
  (60823674, 671, '{A,G}'::varchar[], '{0.2244,0.7756}')
  $$
);

SELECT * FROM finish();
ROLLBACK;
