BEGIN;
SELECT * FROM plan(1);

SELECT set_eq(
  'SELECT snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 367896724',
  $$ VALUES
  (367896724,'A'::varchar,'{AC}'::varchar[],'{0.3363}'::real[])
  $$
);

SELECT * FROM finish();
ROLLBACK;
