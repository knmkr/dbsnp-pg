-- ftp.ncbi.nih.gov:/snp/database/shared_schema/dbSNP_main_table.sql.gz

-- CREATE TABLE [Allele]
-- (
-- [allele_id] [int] IDENTITY(1,1) NOT NULL ,
-- [allele] [varchar](1024) NOT NULL ,
-- [create_time] [smalldatetime] NOT NULL ,
-- [rev_allele_id] [int] NULL ,
-- [src] [varchar](10) NULL ,
-- [last_updated_time] [smalldatetime] NULL ,
-- [allele_left] [varchar](900) NULL
-- )
DROP TABLE IF EXISTS Allele;
CREATE TABLE Allele (
       allele_id          serial         not null,  -- 1,2,3,...
       allele             varchar(1024)  not null,
       create_time        timestamp,  -- default CURRENT_TIMESTAMP,
       rev_allele_id      integer,
       src                varchar(10),
       last_updated_time  timestamp,  -- default CURRENT_TIMESTAMP,
       allele_left        varchar(900)
);

-- CREATE TABLE [SnpChrCode]
-- (
-- [code] [varchar](8) NOT NULL ,
-- [abbrev] [varchar](20) NOT NULL ,
-- [descrip] [varchar](255) NOT NULL ,
-- [create_time] [smalldatetime] NOT NULL ,
-- [sort_order] [tinyint] NULL ,
-- [db_name] [varchar](32) NULL ,
-- [NC_acc] [varchar](16) NULL
-- )
DROP TABLE IF EXISTS SnpChrCode;
CREATE TABLE SnpChrCode (
       code             varchar(8)      not null,
       abbrev           varchar(20)     not null,
       descrip          varchar(255)    not null,
       create_time      timestamp       not null,
       sort_order       smallint,
       db_name          varchar(32),
       NC_acc           varchar(16)
);


-- ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/organism_schema/human_9606_table.sql.gz

-- DROP TABLE IF EXISTS SNPHistory;
-- CREATE TABLE SNPHistory (
--        snp_id          integer  primary key,
--        create_time     timestamp,
--        last_updated_time        timestamp,
--        history_create_time      timestamp,
--        sometext1                 text,
--        sometext2                 text
-- );

-- CREATE TABLE [RsMergeArch]                 -- refSNP(rs) cluster is based on unique genome position. On new genome assembly, previously different contig may
--                                               align. So different rs clusters map to the same location. In this case, we merge the rs. This table tracks this merging.
-- (
-- [rsHigh] [int] NOT NULL ,                  -- Since rs# is assigned sequentially. Low number means the rs occurs early. So we always merge high rs number into low rs number.
-- [rsLow] [int] NOT NULL ,
-- [build_id] [int] NULL ,                    -- dbSNP build id when this rsHigh was merged into rsLow.
-- [orien] [tinyint] NULL ,                   -- The orientation between rsHigh and rsLow.
-- [create_time] [datetime] NOT NULL ,
-- [last_updated_time] [datetime] NOT NULL ,
-- [rsCurrent] [int] NULL ,
-- [orien2Current] [tinyint] NULL ,
-- [comment] [varchar](255) NULL
-- )
DROP TABLE IF EXISTS RsMergeArch;
CREATE TABLE RsMergeArch (
       rsHigh            integer        not null,
       rsLow             integer        not null,
       build_id          smallint,
       orien             bit,
       create_time       timestamp,
       last_updated_time timestamp,
       rsCurrent         integer,
       orien2Current     bit,
       comment           varchar(255)
);

-- CREATE TABLE [b141_SNPChrPosOnRef]  -- This table stores the chromosome position(0 based) of uniquely mapped snp on NCBI reference assembly. It has one
--                                        row for each snp in SNP table. For snp with ambiguous mappings(weight>1, please see SNPMapInfo for weight
--                                        description), the chromosome position is NULL. To get the positions of ambiguous mapped snp, please see
--                                        SNPContigLoc.
--                                        Please note that the actually table name in database has dbSNP build prefix and NCBI genome build suffix. For ex.
--                                        human dbSNP build 130 maps to NCBI 36.3. The table name for this build is: b130_SNPChrPosOnRef_36_3.
-- (
-- [snp_id] [int] NOT NULL ,           -- snp_id refers to SNP.snp_id. Also called 'rs#'.
-- [chr] [varchar](32) NOT NULL ,      -- chr refers to SnpChrCode. Please see value at: ftp://ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz
-- [pos] [int] NULL ,                  -- pos is the 0 based chromosome position of uniquely mapped snp. This value is from SNPContigLoc.phys_pos_from field. Not uniquely mapped snp(weight>1) has NULL in this field.
-- [orien] [int] NULL ,                -- snp to chromosome orientation. 0 - same orientation(orsame strand), 1 - opposite strand
-- [neighbor_snp_list] [int] NULL ,    -- Internal use.
-- [isPAR] [varchar](1) NOT NULL       -- The snp is in Pseudoautosomal Region (PAR) region when isPAR value is 'y'.
-- )
DROP TABLE IF EXISTS SNPChrPosOnRef;
CREATE TABLE SNPChrPosOnRef (
       snp_id                    integer,
       chr                       varchar(32)    not null,
       pos                       integer,
       orien                     bit,
       neighbor_snp_list         integer,
       isPAR                     varchar(1)     not null
);
