BEGIN;
SELECT * FROM plan(1);

SELECT set_eq(
  'SELECT snp_id,snp_current,allele,freq::text FROM get_tbl_allele_freq_by_rs_history(ARRAY[671, 2230021, 4134524, 4986830, 60823674])',
  $$ VALUES
  (671,      671, '{G,A}'::varchar[], '{0.8,0.2}'),
  (2230021,  671, '{G,A}'::varchar[], '{0.8,0.2}'),
  (4134524,  671, '{G,A}'::varchar[], '{0.8,0.2}'),
  (4986830,  671, '{G,A}'::varchar[], '{0.8,0.2}'),
  (60823674, 671, '{G,A}'::varchar[], '{0.8,0.2}')
  $$
);

SELECT * FROM finish();
ROLLBACK;
