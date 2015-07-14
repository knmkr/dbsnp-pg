BEGIN;
SELECT * FROM no_plan();

SELECT is(get_current_rs(332), 121909001);
SELECT is(get_current_rs(2230021), 671);
SELECT is(get_current_rs(4134524), 671);
SELECT is(get_current_rs(4986830), 671);
SELECT is(get_current_rs(60823674), 671);

SELECT * FROM finish();
ROLLBACK;
