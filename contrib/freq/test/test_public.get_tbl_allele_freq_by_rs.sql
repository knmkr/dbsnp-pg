BEGIN;
SELECT * FROM plan(6);

SELECT set_eq(
  'SELECT snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 367896724',
  $$ VALUES
  (367896724,'{A}'::varchar[],'{AC}'::varchar[],'{0.3363}'::real[])
  $$
);

SELECT set_eq(
  'SELECT chr,pos,snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 1',
  $$ VALUES
  ('X'::varchar,1,1,'{G,G}'::varchar[],'{A,C}'::varchar[],'{0.2,0.5}'::real[])
  $$
);
SELECT set_eq(
  'SELECT chr,pos,snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 2',
  $$ VALUES
  ('X'::varchar,1,2,'{G}'::varchar[],'{T}'::varchar[],'{0.3}'::real[])
  $$
);
SELECT set_eq(
  'SELECT chr,pos,snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 3',
  $$ VALUES
  ('X'::varchar,2,3,'{G,G}'::varchar[],'{A,T}'::varchar[],'{0.1,0.2}'::real[])
  $$
);
SELECT set_eq(
  'SELECT chr,pos,snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 4',
  $$ VALUES
  ('X'::varchar,3,4,'{G,G}'::varchar[],'{GC,GCC}'::varchar[],'{0.3,0.4}'::real[])
  $$
);
SELECT set_eq(
  'SELECT chr,pos,snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3_b37 WHERE snp_id = 5',
  $$ VALUES
  ('X'::varchar,3,5,'{G}'::varchar[],'{GAA}'::varchar[],'{0.1}'::real[])
  $$
);

SELECT * FROM finish();
ROLLBACK;
