BEGIN;
SELECT * FROM plan(1);

SELECT is(get_pos_by_rs(10)::text, '(7,92383888)');

SELECT * FROM finish();
ROLLBACK;
