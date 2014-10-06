DROP TABLE IF EXISTS tmp_rs2current;
CREATE TABLE tmp_rs2current (
       id                serial    primary key,  -- 1,2,3,...
       rsHigh            integer,
       rsCurrent         integer,
       orien2Current     bit
);
