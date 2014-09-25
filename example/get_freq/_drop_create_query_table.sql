DROP TABLE IF EXISTS tmp_rs2current;
CREATE TABLE tmp_rs2current (
       rsHigh            integer        primary key,
       rsCurrent         integer,
       orien2Current     integer  -- TODO: bit
);
