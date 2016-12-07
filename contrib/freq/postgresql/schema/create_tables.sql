-- List of partitioning key
DROP TABLE IF EXISTS AlleleFreqSource CASCADE;
CREATE TABLE AlleleFreqSource (
       source_id    smallint    primary key,
       project      varchar     not null,
       populations  varchar[]   not null,
       genome_build varchar,
       status       varchar,
       display_name varchar
);
INSERT INTO AlleleFreqSource VALUES (1,   '1000 Genomes Phase 1',  '{JPT}',          'b37',  '',  '1000 Genomes Phase1 JPT'),
                                    (2,   '1000 Genomes Phase 3',  '{JPT}',          'b37',  '',  '1000 Genomes Phase3 JPT'),
                                    (3,   '1000 Genomes Phase 1',  '{CHB,JPT,CHS}',  'b37',  '',  '1000 Genomes Phase1 CHB+JPT+CHS'),
                                    (4,   '1000 Genomes Phase 3',  '{CHB,JPT,CHS}',  'b37',  '',  '1000 Genomes Phase3 CHB+JPT+CHS'),
                                    (100, '1000 Genomes Phase 3',  '{CEU}',          'b37',  '',  '1000 Genomes Phase3 CEU'),
                                    (200, '1000 Genomes Phase 3',  '{YRI}',          'b37',  '',  '1000 Genomes Phase3 YRI'),
                                    (300, '1000 Genomes Phase 3',  '{Global}',       'b37',  '',  '1000 Genomes Phase3 Global');

-- Partitioning "master" table
DROP TABLE IF EXISTS AlleleFreq CASCADE;
CREATE TABLE AlleleFreq (
       snp_id        integer          not null,
       "ref"         varchar(1024)    not null,
       allele        varchar(1024)[]  not null,
       freq          real[]           not null,
       freqx         integer[]        not null,
       source_id     smallint         references AlleleFreqSource(source_id)
);

-- Partitioning "child" table
CREATE TABLE AlleleFreq_1   ( CHECK ( source_id = 1 )   ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_2   ( CHECK ( source_id = 2 )   ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_3   ( CHECK ( source_id = 3 )   ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_4   ( CHECK ( source_id = 4 )   ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_100 ( CHECK ( source_id = 100 ) ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_200 ( CHECK ( source_id = 200 ) ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_300 ( CHECK ( source_id = 300 ) ) INHERITS (AlleleFreq);

-- Partitioning trigger function
CREATE OR REPLACE FUNCTION allelefreq_insert_trigger()
RETURNS TRIGGER AS $$
    BEGIN
        IF ( NEW.source_id = 1 ) THEN
            INSERT INTO allelefreq_1 VALUES (NEW.*);
        ELSIF ( NEW.source_id = 2 ) THEN
            INSERT INTO allelefreq_2 VALUES (NEW.*);
        ELSIF ( NEW.source_id = 3 ) THEN
            INSERT INTO allelefreq_3 VALUES (NEW.*);
        ELSIF ( NEW.source_id = 4 ) THEN
            INSERT INTO allelefreq_4 VALUES (NEW.*);
        ELSIF ( NEW.source_id = 100 ) THEN
            INSERT INTO allelefreq_100 VALUES (NEW.*);
        ELSIF ( NEW.source_id = 200 ) THEN
            INSERT INTO allelefreq_200 VALUES (NEW.*);
        ELSIF ( NEW.source_id = 300 ) THEN
            INSERT INTO allelefreq_300 VALUES (NEW.*);
        ELSE
            RAISE EXCEPTION 'Invalid source_id in allelefreq_insert_trigger()';
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

-- Set trigger
CREATE TRIGGER insert_alllefreq_trigger
    BEFORE INSERT ON allelefreq
    FOR EACH ROW EXECUTE PROCEDURE allelefreq_insert_trigger();
