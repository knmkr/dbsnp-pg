BEGIN;
SELECT * FROM no_plan();

SELECT is(get_current_rs(ARRAY[332])::text, '(332,,121909001,121909001)');
SELECT is(get_current_rs(ARRAY[2230021])::text, '(2230021,,671,671)');
SELECT is(get_current_rs(ARRAY[4134524])::text, '(4134524,,671,671)');
SELECT is(get_current_rs(ARRAY[4986830])::text, '(4986830,,671,671)');
SELECT is(get_current_rs(ARRAY[60823674])::text, '(60823674,,671,671)');

SELECT * FROM finish();
ROLLBACK;
