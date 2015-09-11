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
                                    (4, '1000genomes_phase3', '{CHB,JPT,CHS}', 'b37');

-- Partitioning "master" table
DROP TABLE IF EXISTS AlleleFreq CASCADE;
CREATE TABLE AlleleFreq (
       snp_id    integer        not null,
       chr       varchar(32)    not null,
       pos       integer        not null,
       allele    varchar(1024)  not null,
       freq      real           not null,
       source_id smallint       references AlleleFreqSource(source_id)
);

-- Partitioning "child" table
CREATE TABLE AlleleFreq_1 ( CHECK ( source_id = 1 ) ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_2 ( CHECK ( source_id = 2 ) ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_3 ( CHECK ( source_id = 3 ) ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_4 ( CHECK ( source_id = 4 ) ) INHERITS (AlleleFreq);

-- Constraints on "child" table
DROP INDEX IF EXISTS allelefreq_1_ukey_snp_id_allele;
DROP INDEX IF EXISTS allelefreq_2_ukey_snp_id_allele;
DROP INDEX IF EXISTS allelefreq_3_ukey_snp_id_allele;
DROP INDEX IF EXISTS allelefreq_4_ukey_snp_id_allele;
CREATE UNIQUE INDEX allelefreq_1_ukey_snp_id_allele ON AlleleFreq_1 (snp_id, allele);
CREATE UNIQUE INDEX allelefreq_2_ukey_snp_id_allele ON AlleleFreq_2 (snp_id, allele);
CREATE UNIQUE INDEX allelefreq_3_ukey_snp_id_allele ON AlleleFreq_3 (snp_id, allele);
CREATE UNIQUE INDEX allelefreq_4_ukey_snp_id_allele ON AlleleFreq_4 (snp_id, allele);

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
