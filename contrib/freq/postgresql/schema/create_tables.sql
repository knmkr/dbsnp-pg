-- List of partitioning key
DROP TABLE IF EXISTS AlleleFreqSource CASCADE;
CREATE TABLE AlleleFreqSource (
       source_id    smallint    primary key,
       project      varchar     not null,
       populations  varchar[]   not null,
       genome_build varchar
);
INSERT INTO AlleleFreqSource VALUES (1, '1000genomes_phase1', '{CHB,JPT}', 'b37'),
                                    (2, '1000genomes_phase3', '{CHB,JPT}', 'b37'),
                                    (3, '1000genomes_phase1', '{CHB,JPT,CHS}', 'b37'),
                                    (4, '1000genomes_phase3', '{CHB,JPT,CHS}', 'b37'),
                                    (5, '1000genomes_phase3', '{CHB}', 'b37'),
                                    (6, '1000genomes_phase3', '{JPT}', 'b37'),
                                    (100, '1000genomes_phase3', '{CEU}', 'b37'),
                                    (200, '1000genomes_phase3', '{YRI}', 'b37');

-- Partitioning "master" table
DROP TABLE IF EXISTS AlleleFreq CASCADE;
CREATE TABLE AlleleFreq (
       snp_id    integer          not null,
       allele    varchar(1024)[]  not null,
       freq      real[]           not null,
       source_id smallint         references AlleleFreqSource(source_id)
);

-- Partitioning "child" table
-- CREATE TABLE AlleleFreq_1 ( CHECK ( source_id = 1 ) ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_2 ( CHECK ( source_id = 2 ) ) INHERITS (AlleleFreq);
-- CREATE TABLE AlleleFreq_3 ( CHECK ( source_id = 3 ) ) INHERITS (AlleleFreq);
-- CREATE TABLE AlleleFreq_4 ( CHECK ( source_id = 4 ) ) INHERITS (AlleleFreq);
-- CREATE TABLE AlleleFreq_5 ( CHECK ( source_id = 5 ) ) INHERITS (AlleleFreq);
-- CREATE TABLE AlleleFreq_6 ( CHECK ( source_id = 6 ) ) INHERITS (AlleleFreq);
-- CREATE TABLE AlleleFreq_100 ( CHECK ( source_id = 100 ) ) INHERITS (AlleleFreq);
-- CREATE TABLE AlleleFreq_200 ( CHECK ( source_id = 200 ) ) INHERITS (AlleleFreq);

-- Partitioning trigger function
CREATE OR REPLACE FUNCTION allelefreq_insert_trigger()
RETURNS TRIGGER AS $$
    BEGIN
        -- IF ( NEW.source_id = 1 ) THEN
        --     INSERT INTO allelefreq_1 VALUES (NEW.*);
        IF ( NEW.source_id = 2 ) THEN
            INSERT INTO allelefreq_2 VALUES (NEW.*);
        -- ELSIF ( NEW.source_id = 3 ) THEN
        --     INSERT INTO allelefreq_3 VALUES (NEW.*);
        -- ELSIF ( NEW.source_id = 4 ) THEN
        --     INSERT INTO allelefreq_4 VALUES (NEW.*);
        -- ELSIF ( NEW.source_id = 5 ) THEN
        --     INSERT INTO allelefreq_5 VALUES (NEW.*);
        -- ELSIF ( NEW.source_id = 6 ) THEN
        --     INSERT INTO allelefreq_6 VALUES (NEW.*);
        -- ELSIF ( NEW.source_id = 100 ) THEN
        --     INSERT INTO allelefreq_100 VALUES (NEW.*);
        -- ELSIF ( NEW.source_id = 200 ) THEN
        --     INSERT INTO allelefreq_200 VALUES (NEW.*);
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
