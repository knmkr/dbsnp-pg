DROP TABLE IF EXISTS _b141_SNPChrPosOnRef_GRCh37p13;
CREATE TABLE _b141_SNPChrPosOnRef_GRCh37p13 (
       snp_id                    integer,
       chr                       varchar(32)    not null, -- chromosome
       pos                       integer,                 -- position (0-based)
       orien                     bit,                     -- snp to chromosome orientation
       allele                    varchar(1)               -- reference allele
);
