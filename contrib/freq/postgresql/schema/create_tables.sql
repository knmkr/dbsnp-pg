--
-- ##reference=ftp://ftp.1000genomes.ebi.ac.uk//vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
DROP TABLE IF EXISTS AlleleFreqIn1000GenomesPhase3_b37;
CREATE TABLE AlleleFreqIn1000GenomesPhase3_b37 (
       chr       varchar(32),     -- b37
       pos       integer,         -- b37
       snp_id    integer,         -- "." in VCF => NULL
       ref       varchar(1024)    not null,
       alt       varchar(1024)[]  not null,
       freq_eas  real[],
       freq_eur  real[],
       freq_afr  real[],
       freq_amr  real[],
       freq_sas  real[]
);
