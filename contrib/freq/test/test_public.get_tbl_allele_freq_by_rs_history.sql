BEGIN;
SELECT * FROM plan(1);

SELECT set_eq(
  'SELECT * FROM get_tbl_allele_freq_by_rs_history(ARRAY[671, 2230021, 4134524, 4986830, 60823674])',
  $$ VALUES
  (671,      671, '{G}'::varchar[],'{A}'::varchar[],'{0.1736}'::real[]),
  (2230021,  671, '{G}'::varchar[],'{A}'::varchar[],'{0.1736}'::real[]),
  (4134524,  671, '{G}'::varchar[],'{A}'::varchar[],'{0.1736}'::real[]),
  (4986830,  671, '{G}'::varchar[],'{A}'::varchar[],'{0.1736}'::real[]),
  (60823674, 671, '{G}'::varchar[],'{A}'::varchar[],'{0.1736}'::real[])
  $$
);

SELECT * FROM finish();
ROLLBACK;
