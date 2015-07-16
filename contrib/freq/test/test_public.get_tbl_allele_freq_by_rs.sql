BEGIN;
SELECT * FROM plan(3);

SELECT set_eq(
  'SELECT snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 367896724',
  $$ VALUES
  (367896724,'A'::varchar,'{AC}'::varchar[],'{0.3363}'::real[])
  $$
);

SELECT set_eq(
  'SELECT chr,pos,snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 1',
  $$ VALUES
  ('X'::varchar,1,1,'G'::varchar,'{A,C}'::varchar[],'{0.2,0.5}'::real[])
  $$
);
SELECT set_eq(
  'SELECT chr,pos,snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 2',
  $$ VALUES
  ('X'::varchar,1,2,'G'::varchar,'{T}'::varchar[],'{0.3}'::real[])
  $$
);

SELECT * FROM finish();
ROLLBACK;
