BEGIN;
SELECT * FROM plan(1);

SELECT is(get_pos_by_rs(ARRAY[671])::text, '(671,671,12,112241766)');

SELECT * FROM finish();
ROLLBACK;
