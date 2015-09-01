--
DROP TABLE IF EXISTS AlleleFreqIn1000GenomesPhase3_b37;
CREATE TABLE AlleleFreqIn1000GenomesPhase3_b37 (
       snp_id    integer,
       chr       varchar(32)    not null,
       pos       integer        not null,
       allele    varchar(1024)  not null,
       freq      real           not null
);

DROP TABLE IF EXISTS AlleleFreqIn1000GenomesPhase1_b37;
CREATE TABLE AlleleFreqIn1000GenomesPhase1_b37 (
       snp_id    integer        not null,
       chr       varchar(32)    not null,
       pos       integer        not null,
       allele    varchar(1024)  not null,
       freq      real           not null
);
