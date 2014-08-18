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

-- CREATE TABLE [Population]
-- (
-- [pop_id] [int] NOT NULL ,
-- [handle] [varchar](20) NOT NULL ,
-- [loc_pop_id] [varchar](64) NOT NULL ,
-- [loc_pop_id_upp] [varchar](64) NOT NULL ,
-- [create_time] [smalldatetime] NULL ,
-- [last_updated_time] [smalldatetime] NULL ,
-- [src_id] [int] NULL
-- )
--
-- CREATE NONCLUSTERED INDEX [i_handle_loc_pop_id_upp] ON [Population] ([handle] ASC,[loc_pop_id_upp] ASC)
-- CREATE NONCLUSTERED INDEX [i_handle_loc_pop_id] ON [Population] ([handle] ASC,[loc_pop_id] ASC)
--
-- ALTER TABLE [Population] ADD CONSTRAINT [pk_Population_pop_id]  PRIMARY KEY  CLUSTERED ([pop_id] ASC)
DROP TABLE IF EXISTS Population;
CREATE TABLE Population (
       pop_id            integer      primary key,
       handle            varchar(20)  not null,
       loc_pop_id        varchar(64),  -- not null,
       loc_pop_id_upp    varchar(64),  -- not null,
       create_time       timestamp,
       last_updated_time timestamp,
       src_id            integer
);
CREATE INDEX i_handle_loc_pop_id_upp ON Population (handle, loc_pop_id_upp);
CREATE INDEX i_handle_loc_pop_id ON Population (handle, loc_pop_id);

-- CREATE TABLE [AlleleFreqBySsPop]
-- (
-- [subsnp_id] [int] NOT NULL ,
-- [pop_id] [int] NOT NULL ,
-- [allele_id] [int] NOT NULL ,
-- [source] [varchar](2) NOT NULL ,
-- [cnt] [real] NULL ,
-- [freq] [real] NULL ,
-- [last_updated_time] [datetime] NOT NULL
-- )
--
-- ALTER TABLE [AlleleFreqBySsPop] ADD CONSTRAINT [pk_AlleleFreqBySsPop_b129]  PRIMARY KEY  CLUSTERED ([subsnp_id] ASC,[pop_id] ASC,[allele_id] ASC)
DROP TABLE IF EXISTS AlleleFreqBySsPop;
CREATE TABLE AlleleFreqBySsPop (
       subsnp_id               integer     not null,
       pop_id                  integer     not null,
       allele_id               integer     not null,
       source                  varchar(2)  not null,
       cnt                     real,
       freq                    real,
       last_updated_time       timestamp   not null,
       PRIMARY KEY (subsnp_id, pop_id, allele_id)
);
