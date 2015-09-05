DROP TABLE IF EXISTS AlleleFreqSource CASCADE;
CREATE TABLE AlleleFreqSource (
       source_id    smallint    primary key,
       project      varchar     not null,
       populations  varchar[]   not null,
       genome_build varchar
);
INSERT INTO AlleleFreqSource VALUES (1, '1000genomes_phase1', '{CHB,JPT,CHS}', 'b37'),
                                    (2, '1000genomes_phase3', '{CHB,JPT,CHS}', 'b37'),
                                    (3, 'hapmap',             '{CHB,JPT}',     'b36');

DROP TABLE IF EXISTS AlleleFreq CASCADE;
CREATE TABLE AlleleFreq (
       snp_id    integer        not null,
       chr       varchar(32)    not null,
       pos       integer        not null,
       allele    varchar(1024)  not null,
       freq      real           not null,
       source_id smallint       references AlleleFreqSource(source_id)
);

CREATE TABLE AlleleFreq_1 ( CHECK ( source_id = 1 ) ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_2 ( CHECK ( source_id = 2 ) ) INHERITS (AlleleFreq);
CREATE TABLE AlleleFreq_3 ( CHECK ( source_id = 3 ) ) INHERITS (AlleleFreq);
