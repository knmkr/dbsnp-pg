-- ftp.ncbi.nih.gov:/snp/database/shared_schema/dbSNP_main_table.sql.gz
--                                             /dbSNP_main_index.sql.gz
--                                             /dbSNP_main_constraint.sql.gz

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
--
-- CREATE NONCLUSTERED INDEX [i_rev_allele_id] ON [Allele] ([rev_allele_id] ASC)
--
-- ALTER TABLE [Allele] ADD CONSTRAINT [df_Allele_create_time] DEFAULT (GETDATE()) FOR [create_time]
-- ALTER TABLE [Allele] ADD CONSTRAINT [df_Allele_update_time] DEFAULT (GETDATE()) FOR [last_updated_time]
-- ALTER TABLE [Allele] ADD CONSTRAINT [pk_Allele]  PRIMARY KEY  CLUSTERED ([allele_id] ASC)
DROP TABLE IF EXISTS Allele;
CREATE TABLE Allele (
       allele_id          serial         primary key,  -- 1,2,3,...
       allele             varchar(1024)  not null,
       create_time        timestamp      default CURRENT_TIMESTAMP,
       rev_allele_id      integer,
       src                varchar(10),
       last_updated_time  timestamp      default CURRENT_TIMESTAMP,
       allele_left        varchar(900)
);
CREATE INDEX i_rev_allele_id ON Allele (rev_allele_id);


-- ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/organism_schema/human_9606_table.sql.gz
--                                                                    /human_9606_index.sql.gz
--                                                                    /human_9606_constraint.sql.gz

--
-- DROP TABLE IF EXISTS SNPHistory;
-- CREATE TABLE SNPHistory (
--        snp_id          integer  primary key,
--        create_time     timestamp,
--        last_updated_time        timestamp,
--        history_create_time      timestamp,
--        sometext1                 text,
--        sometext2                 text
-- );

--
DROP TABLE IF EXISTS RsMergeArch;
CREATE TABLE RsMergeArch (
       rsHigh            integer        primary key,
       rsLow             integer,
       build_id          smallint,
       orien             smallint,
       create_time       timestamp,
       last_updated_time timestamp,
       rsCurrent         integer        not null,
       orien2Current     smallint,
       sometext1         text
);

--
DROP TABLE IF EXISTS b141_SNPChrPosOnRef;
CREATE TABLE b141_SNPChrPosOnRef (
       snp_id                    integer        primary key,
       chr                       varchar(32)    not null,
       pos                       integer,
       orien                     integer,
       neighbor_snp_list         integer,
       isPAR                     varchar(1)     not null
);
