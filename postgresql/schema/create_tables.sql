-- Table/column description: http://www.ncbi.nlm.nih.gov/projects/SNP/snp_db_list_table.cgi?

-- Schema: ftp.ncbi.nih.gov:/snp/database/shared_schema/dbSNP_main_table.sql.gz

-- CREATE TABLE [Allele]
-- (
-- [allele_id] [int] IDENTITY(1,1) NOT NULL ,
-- [allele] [varchar](1024) NOT NULL ,
-- [create_time] [smalldatetime] NOT NULL ,
-- [rev_allele_id] [int] NULL ,
-- [src] [varchar](10) NULL ,
-- [last_updated_time] [smalldatetime] NULL ,
-- [allele_left] [varchar](900) NULL,
-- [allele_md5] [binary] NULL
-- )
DROP TABLE IF EXISTS Allele;
CREATE TABLE Allele (
       allele_id          serial         not null,  -- 1,2,3,...
       allele             varchar(1024)  not null,
       create_time        timestamp,  -- default CURRENT_TIMESTAMP,
       rev_allele_id      integer,
       src                varchar(10),
       last_updated_time  timestamp,  -- default CURRENT_TIMESTAMP,
       allele_left        varchar(900),
       allele_md5         bytea
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


-- Schema: ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/data/organism_schema/human_9606_table.sql.gz
-- Column Description: http://www.ncbi.nlm.nih.gov/projects/SNP/snp_db_table_description.cgi?t=<table_name>

-- CREATE TABLE [OmimVarLocusIdSNP]
-- (
-- [omim_id] [int] NOT NULL ,
-- [locus_id] [int] NULL ,
-- [omimvar_id] [char](4) NULL ,
-- [locus_symbol] [char](10) NULL ,
-- [var1] [char](20) NULL ,
-- [aa_position] [int] NULL ,
-- [var2] [char](20) NULL ,
-- [var_class] [int] NOT NULL ,
-- [snp_id] [int] NOT NULL
-- )
DROP TABLE IF EXISTS OmimVarLocusIdSNP;
CREATE TABLE OmimVarLocusIdSNP (
       omim_id       integer   not null,
       locus_id      integer,
       omimvar_id    char(4),
       locus_symbol  char(10),
       var1          char(20),
       aa_position   integer,
       var2          char(20),
       var_class     integer   not null,
       snp_id        integer   not null
);


-- CREATE TABLE [RsMergeArch]                 -- refSNP(rs) cluster is based on unique genome position. On new genome assembly, previously different contig may
--                                               align. So different rs clusters map to the same location. In this case, we merge the rs. This table tracks this merging.
-- (
-- [rsHigh] [bigint] NOT NULL ,                  -- Since rs# is assigned sequentially. Low number means the rs occurs early. So we always merge high rs number into low rs number.
-- [rsLow] [bigint] NOT NULL ,
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
       rsHigh            bigint        not null,
       rsLow             bigint        not null,
       build_id          smallint,
       orien             bit,
       create_time       timestamp,
       last_updated_time timestamp,
       rsCurrent         integer,
       orien2Current     bit,
       comment           varchar(255)
);

-- CREATE TABLE [SNP]                     -- refSNP property table.
-- (
-- [snp_id] [bigint] NULL ,               -- RefSNP Cluster Id. This is the ubiquitous rs# for dbSNP RefSNP.
-- [avg_heterozygosity] [real] NULL ,     -- The average heterozygosity of a snp. This field has value when there is frequency data for the snp.
-- [het_se] [real] NULL ,                 -- Standard error of the the above average heterozygosity.
-- [create_time] [datetime] NULL ,        -- The first time this refSNP cluster is created.
-- [last_updated_time] [datetime] NULL ,  -- Last time this row of SNP data is updated. This is implementation specific. It does not mean the last time the snp submission data is updated. For ex. This time could be when validation_status was updated for this snp.
-- [CpG_code] [tinyint] NULL ,            -- CpG_code describes the DNA CpG motif. This is a foreign key to lookup table CpGCode.
-- [tax_id] [int] NULL ,                  -- NCBI taxonomy id for an organism.
-- [validation_status] [tinyint] NULL ,   -- This is a foreign key to lookup table SnpValidatonCode, which describes the definition of each validation status.
-- [exemplar_subsnp_id] [bigint] NOT NULL ,  -- snp_id is the id for a refSNP Cluster of one or more submitted snp that all have the same mapping positions. The subsnp_id ( id for the submitted snp) with the longest flanking sequence is the exemplar_subsnp_id. An rs fasta sequence is the sequence of the exemplar ss ( may be in the reverse orientation. See SNPSubSNPLink.substrand_reversed_flag for more details. )
-- [univar_id] [int] NULL ,               -- Uni-variation id. This is the foreign key to lookup table UniVariation. Each submitted snp has a variation( See ObsVariation Table). UniVariation standardize on the order of each allele and corrects typo/format problems of the submitted variations. Many observed variation in submitted snp may be curated to be the same univariation. For ex. -/ATATAT is the same as -/(AT)3.
-- [cnt_subsnp] [int] NULL ,              -- Number of submitted snp (subsnp, or ss) in the refSNP cluster.
-- [map_property] [tinyint] NULL          -- Stores interim data for internal use only
-- )

DROP TABLE IF EXISTS SNP;
CREATE TABLE SNP (
       snp_id              bigint,
       avg_heterozygosity  real,
       het_se              real,
       create_time         timestamp,
       last_updated_time   timestamp,
       CpG_code            smallint,
       tax_id              integer,
       validation_status   smallint,
       exemplar_subsnp_id  bigint     not null,
       univar_id           integer,
       cnt_subsnp          integer,
       map_property        smallint
);

-- CREATE TABLE [SNP3D]                 -- SNP linked to 3D structure.
-- (
-- [snp_id] [int] NOT NULL ,            -- snp_id, foreign key to SNP table.
-- [protein_acc] [char](50) NOT NULL ,  -- Accession of protein this snp is on.
-- [master_gi] [int] NOT NULL ,         -- The gi of the protein.
-- [neighbor_gi] [int] NOT NULL ,       -- The gi of the neighbor (related) protein structure.
-- [aa_position] [int] NOT NULL ,       -- Amino acid position on the master protein gi.
-- [var_res] [char](100) NOT NULL ,     -- Amino acid with the snp variance.
-- [contig_res] [char](3) NOT NULL ,    -- Amino acid with the contig allele.
-- [neighbor_res] [char](3) NOT NULL ,  -- Amino acid on the neighbor protein structure.
-- [neighbor_pos] [int] NOT NULL ,      -- Amino acide position on the neighbor protein structure.
-- [var_color] [int] NOT NULL ,         -- 1- synonnymous: orange;2- nonsynonymous: green
-- [var_label] [int] NOT NULL           -- 1 - Neighbor protein is labeled if the amino acid is identical to the one on the master
--                                         protein. Otherwise, this value is 0.
DROP TABLE IF EXISTS SNP3D;
CREATE TABLE SNP3D (
       snp_id        integer    not null,
       protein_acc   char(50)   not null,
       master_gi     integer    not null,
       neighbor_gi   integer    not null,
       aa_position   integer    not null,
       var_res       char(100)  not null,
       contig_res    char(3)    not null,
       neighbor_res  char(3)    not null,
       neighbor_pos  integer    not null,
       var_color     integer    not null,
       var_label     integer    not null
);

-- CREATE TABLE [b144_ContigInfo_105]              -- ContigInfo has the information for each contig the snp has mapped to. All position is 0 based.
-- (
-- [ctg_id] [int] NOT NULL ,                       -- contig id. This id is unqiue across all organisms. It is constructed as tax_id *
--                                                    100,000 + N, where N is a sequential number of the contig.
--                                                    ctg_id corresponds to a unique combination of NCBI contig accession and
--                                                    version.
--                                                    In databases, ContigInfo tablename has a prefix of snp build id and a suffix of
--                                                    NCBI genome build id.
--                                                    If the same contig is used in two genome build, the ctg_id remains the same
--                                                    and is present in both ContigInfo table.
--                                                    For ex. ctg_id 960600001 is for NT_077402.1, which is in both human build
--                                                    35.1 and 36.1.
--                                                    So this ctg_id record is in both table b126_ContigInfo_35_1 and b125_ContigInfo_36_1.
-- [tax_id] [int] NOT NULL ,
-- [contig_acc] [varchar](32) NOT NULL ,
-- [contig_ver] [smallint] NOT NULL ,
-- [contig_name] [varchar](63) NULL ,
-- [contig_chr] [varchar](32) NULL ,               -- The chromosome the contig is on.
-- [contig_start] [int] NULL ,
-- [contig_end] [int] NULL ,
-- [orient] [tinyint] NULL ,
-- [contig_gi] [int] NOT NULL ,
-- [group_term] [varchar](32) NULL ,
-- [group_label] [varchar](32) NULL ,
-- [contig_label] [varchar](32) NULL ,             -- Label used to label a particular contig in an assembly. For example, in mouse,
--                                                    the NCBI-assembly team have grouped all contigs that are of
--                                                    type 129/??? for annotation purposes. When the NCBI-assembly team display
--                                                    a particular contig, it would be useful to display the actual strain name (129/Sv,
--                                                    129/Ola, etc). Example values: C57BL/6J,129/SvJ,129/SvEvTac
-- [primary_fl] [tinyint] NOT NULL ,
-- [genbank_gi] [int] NULL ,
-- [genbank_acc] [varchar](32) NULL ,
-- [genbank_ver] [smallint] NULL ,
-- [build_id] [int] NOT NULL ,
-- [build_ver] [int] NOT NULL ,
-- [last_updated_time] [smalldatetime] NOT NULL ,
-- [placement_status] [tinyint] NOT NULL ,
-- [asm_acc] [varchar](32) NOT NULL ,
-- [asm_version] [smallint] NOT NULL ,
-- [chr_gi] [int] NULL ,
-- [par_fl] [tinyint] NULL ,
-- [top_level_fl] [tinyint] NOT NULL ,
-- [gen_rgn] [varchar](32) NULL ,
-- [contig_length] [int] NULL
-- )
DROP TABLE IF EXISTS ContigInfo;
CREATE TABLE ContigInfo (
    ctg_id             integer      not null,
    tax_id             integer      not null,
    contig_acc         varchar(32)  not null,
    contig_ver         smallint     not null,
    contig_name        varchar(63),
    contig_chr         varchar(32),
    contig_start       integer,
    contig_end         integer,
    orient             smallint,
    contig_gi          integer      not null,
    group_term         varchar(32),
    group_label        varchar(32),
    contig_label       varchar(32),
    primary_fl         smallint     not null,
    genbank_gi         integer,
    genbank_acc        varchar(32),
    genbank_ver        smallint,
    build_id           integer      not null,
    build_ver          integer      not null,
    last_updated_time  timestamp    not null,
    placement_status   smallint     not null,
    asm_acc            varchar(32)  not null,
    asm_version        smallint     not null,
    chr_gi             integer,
    par_fl             smallint,
    top_level_fl       smallint     not null,
    gen_rgn            varchar(32),
    contig_length      integer
);

-- CREATE TABLE [b150_SNPChrPosOnRef_108]  -- This table stores the chromosome position(0 based) of uniquely mapped snp on NCBI reference assembly. It has one
--                                        row for each snp in SNP table. For snp with ambiguous mappings(weight>1, please see SNPMapInfo for weight
--                                        description), the chromosome position is NULL. To get the positions of ambiguous mapped snp, please see
--                                        SNPContigLoc.
--                                        Please note that the actually table name in database has dbSNP build prefix and NCBI genome build suffix. For ex.
--                                        human dbSNP build 130 maps to NCBI 36.3. The table name for this build is: b130_SNPChrPosOnRef_36_3.
-- (
-- [snp_id] [bigint] NOT NULL ,        -- snp_id refers to SNP.snp_id. Also called 'rs#'.
-- [chr] [varchar](32) NOT NULL ,      -- chr refers to SnpChrCode. Please see value at: ftp://ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz
-- [pos] [int] NULL ,                  -- pos is the 0 based chromosome position of uniquely mapped snp. This value is from SNPContigLoc.phys_pos_from field. Not uniquely mapped snp(weight>1) has NULL in this field.
-- [orien] [int] NULL ,                -- snp to chromosome orientation. 0 - same orientation(orsame strand), 1 - opposite strand
-- [neighbor_snp_list] [int] NULL ,    -- Internal use.
-- [isPAR] [varchar](1) NOT NULL       -- The snp is in Pseudoautosomal Region (PAR) region when isPAR value is 'y'.
-- )
DROP TABLE IF EXISTS SNPChrPosOnRef;
CREATE TABLE SNPChrPosOnRef (
       snp_id                    bigint,
       chr                       varchar(32)    not null,
       pos                       integer,
       orien                     bit,
       neighbor_snp_list         integer,
       isPAR                     varchar(1)     not null
);

-- CREATE TABLE [b150_SNPContigLoc_108]        -- SNPContigLoc table stores snp mapping positions to contigs in all assemblies. A snp may have different map positions
--                                                on different genome builds. To make the genome build number/version explicit, the table name is suffixed with
--                                                "_build_ver" and prefixed with snp build number. For ex. in dbSNP build 125, human snp is both mapped to NCBI build
--                                                35.1 and build 34.3. So we have two tables: b125_SNPContigLoc_35_1 and b125_SNPContigLoc_34_3. Please note
--                                                that to look for uniquely mapped snp on each assembly (For ex. Human has several assemblies, such as the NCBI
--                                                assembly and the Celera assembly), you need to look at SNPMapInfo and ContigInfo table for the same build. An
--                                                example sql to get all trueSNP that has unique mapping position on NCBI b35.1 reference assembly is:
--
--                                                Select distinct m.snp_id
--                                                From b125_SNPContigLoc_35_1 m join b125_ContigInfo_35_1 i on i.ctg_id = m.ctg_id and i.contig_label='reference'
--                                                Join b125_SNPMapInfo_35_1 w on w.snp_id = m.snp_id and w.assembly = i.contig_label and w.weight = 1
--                                                Join SNP s on s.snp_id = m.snp_id
--                                                Join UniVariation u on u.univar_id = s.univar_id and u.subsnp_class = 1
--
--                                                Please see table descriptions for SNPMapInfo, ContigInfo, SNP, UniVariation for more details.
--
-- (
-- [snp_type] [varchar](2) NOT NULL ,          -- "rs" or "ss". For snp external users, this value should always be "rs". Internally,
--                                                during build prepartion, when the snp is not clustered, the snp_id will be "ss".
-- [snp_id] [bigint] NULL ,                    -- rs#. Foreign key to SNP table.
-- [ctg_id] [int] NULL ,                       -- ctg_id is the foreign key to ContigInfo.
-- [asn_from] [int] NULL ,                     -- Start position of snp on contig, counting from 0. This position is always from the
--                                                beginning of the contig regardless of the snp orienation to contig and
--                                                regardless of the contig orienation to chromosome.
-- [asn_to] [int] NULL ,                       -- end position of snp on contig
-- [lf_ngbr] [int] NULL ,
-- [rf_ngbr] [int] NULL ,
-- [lc_ngbr] [int] NULL ,
-- [rc_ngbr] [int] NULL ,
-- [loc_type] [tinyint] NULL ,
-- [phys_pos_from] [int] NULL ,                -- Start position of snp on chromosome. Phys_pos_from is obtained by adding
--                                                asn_from to the contig start position in ContigInfo table. It is always the position
--                                                from the beginning of the chromosome regardless of the snp orienation to
--                                                contig and regardless of contig orienation to chromosome.
-- [snp_bld_id] [int] NOT NULL ,
-- [last_updated_time] [smalldatetime] NULL ,
-- [process_status] [int] NOT NULL ,
-- [orientation] [int] NULL ,
-- [allele] [varchar](1024) NULL ,
-- [loc_sts_uid] [int] NULL ,
-- [aln_quality] [real] NULL ,
-- [num_mism] [int] NULL ,
-- [num_del] [int] NULL ,
-- [num_ins] [int] NULL ,
-- [tier] [int] NULL
-- )
DROP TABLE IF EXISTS SNPContigLoc;
CREATE TABLE SNPContigLoc (
    snp_type           varchar(2)     not null,
    snp_id             bigint,
    ctg_id             integer,
    asn_from           integer,
    asn_to             integer,
    lf_ngbr            integer,
    rf_ngbr            integer,
    lc_ngbr            integer,
    rc_ngbr            integer,
    loc_type           smallint,
    phys_pos_from      integer,
    snp_bld_id         integer        not null,
    last_updated_time  timestamp,
    process_status     integer        not null,
    orientation        integer,
    allele             varchar(1024),
    loc_sts_uid        integer,
    aln_quality        real,
    num_mism           integer,
    num_del            integer,
    num_ins            integer,
    tier               integer
);

-- CREATE TABLE [b150_MapLinkInfo_108]    -- MapLinkInfo table stores accession.version for the gi in MapLink table.
-- (
-- [gi] [bigint] NOT NULL ,               -- MapLink.gi refers to this gi. This is the gi for RefSeq NM/NG/NR/XR/XM sequence.
-- [accession] [varchar](32) NOT NULL ,   -- This is the accession corresponds to the gi.
-- [accession_ver] [smallint] NOT NULL ,  -- This is the version of the accession corresponds to the gi. gi and accession.ver
--                                           has a one-to-one correspondence. One accession could have several versions
--                                           and each version has a different gi.
-- [acc] [varchar](32) NOT NULL ,
-- [version] [smallint] NOT NULL ,
-- [status] [varchar](32) NULL ,
-- [create_dt] [smalldatetime] NULL ,
-- [update_dt] [smalldatetime] NULL ,
-- [cds_from] [int] NULL ,
-- [cds_to] [int] NULL
-- )
DROP TABLE IF EXISTS MapLinkInfo;
CREATE TABLE MapLinkInfo (
       gi             bigint       not null,
       accession      varchar(32)  not null,
       accession_ver  smallint     not null,
       acc            varchar(32)  not null,
       version        smallint     not null,
       status         varchar(32),
       create_dt      timestamp,
       update_dt      timestamp,
       cds_from       integer,
       cds_to         integer
);

-- CREATE TABLE [b150_MapLink_108]      -- MapLink table stores snp mapping to RefSeq sequences with accession starts with letter: NM, NG, XM, NR, XR.
-- (
-- [snp_type] [char](2) NULL ,          -- "rs" or "ss". For snp external users, this value should always be "rs".
--                                         Internally, during build prepartion, when the snp is not clustered, the snp_id
--                                         will be "ss".
-- [snp_id] [int] NULL ,                -- rs#. Foreign key to SNP table.
-- [gi] [int] NULL ,                    -- NCBI gi. The accession.version for the gi is in MapLinkInfo table.
-- [accession_how_cd] [tinyint] NULL ,  -- Internal code.
-- [offset] [int] NULL ,                -- Start position of snp on the gi, counting from 0. This position is always from
--                                         the beginning of the sequence identified by the gi regardless of the snp
--                                         orienation to the sequence.
-- [asn_to] [int] NULL ,                -- end position of snp on gi
-- [lf_ngbr] [int] NULL ,
-- [rf_ngbr] [int] NULL ,
-- [lc_ngbr] [int] NULL ,
-- [rc_ngbr] [int] NULL ,
-- [loc_type] [tinyint] NULL ,          -- loc_type is a code referring to LocTypeCode. Loc_type describes how snp
--                                         maps to gi. Table LocTypeCode also has the code description.
-- [build_id] [int] NOT NULL ,          -- NCBI build id.
-- [process_time] [datetime] NULL ,
-- [process_status] [tinyint] NULL ,
-- [orientation] [tinyint] NULL ,       -- Orientation of snp_id with respect to gi. 0 means the snp is in the same
--                                         orienation as the gi. 1 means reverse orientation.
-- [allele] [varchar](1024) NULL ,      -- allele on the sequence identified by gi at the snp position. This is always
--                                         in gi strand.
-- [aln_quality] [float] NULL ,
-- [num_mism] [int] NULL ,
-- [num_del] [int] NULL ,
-- [num_ins] [int] NULL ,
-- [tier] [int] NULL ,
-- [ctg_gi] [int] NULL ,
-- [ctg_from] [int] NULL ,
-- [ctg_to] [int] NULL ,
-- [ctg_orient] [tinyint] NULL ,
-- [source] [varchar](64) NULL
-- )
DROP TABLE IF EXISTS MapLink;
CREATE TABLE MapLink (
       snp_type          char(2),
       snp_id            integer,
       gi                integer,
       accession_how_cd  smallint,
       "offset"          integer,
       asn_to            integer,
       lf_ngbr           integer,
       rf_ngbr           integer,
       lc_ngbr           integer,
       rc_ngbr           integer,
       loc_type          smallint,
       build_id          integer         not null,
       process_time      timestamp,
       process_status    smallint,
       orientation       smallint,
       allele            varchar(1024),
       aln_quality       float,
       num_mism          integer,
       num_del           integer,
       num_ins           integer,
       tier              integer,
       ctg_gi            integer,
       ctg_from          integer,
       ctg_to            integer,
       ctg_orient        smallint,
       "source"          varchar(64)
);

-- CREATE TABLE [b150_SNPMapInfo_108]  -- SNPMapInfo has the mapping summary information for snp for each assembly the snp is mapped to for the current
--                                        build. Two columns snp_id and assembly together unqiuely identify each row in this table.
-- (
-- [snp_type] [varchar](2) NOT NULL ,  -- same description as SNPContigLoc.snp_type.
-- [snp_id] [bigint] NULL ,            -- same description as SNPContigLoc.snp_id.
-- [chr_cnt] [int] NOT NULL ,          -- Number of chromosomes the snp has hits on.
-- [contig_cnt] [int] NOT NULL ,       -- Number of contig the snp has hits on.
-- [loc_cnt] [int] NOT NULL ,          -- Number of locations the snp has been mapped to. This could be bigger than
--                                        contig_cnt if a snp hits a contig more than one place.
-- [weight] [int] NOT NULL ,           -- A number that codes for the mapping quality of the snp on each assembly:
--                                        1 = snp aligns at exactly one locus
--                                        2 = snp aligns at two locus on same chromosome
--                                        3 = snp aligns at less than 10 locus
--                                        10= snp aligns at more than 10 locations
-- [hap_cnt] [int] NULL ,
-- [placed_cnt] [int] NOT NULL ,
-- [unlocalized_cnt] [int] NOT NULL ,
-- [unplaced_cnt] [int] NOT NULL ,
-- [aligned_cnt] [int] NOT NULL ,
-- [md5] [char](32) NULL ,
-- [asm_acc] [varchar](32) NULL ,
-- [asm_version] [smallint] NULL ,
-- [assembly] [varchar](32) NULL
-- )
--
-- Mapping Weight
-- ==============
--
-- > Your descriptions of mapweight in the FTP README for Chromosome Reports and for SNPMapInfo in the data dictionary
-- > are contradictory. Which is correct?
--
-- The definitions of map weight for chromosome reports and database tables are indeed different:
--
-- | Chromosome Reports                                                       | Database Tables                                          |
-- |--------------------------------------------------------------------------|----------------------------------------------------------|
-- | Mapweight 1 = Unmapped                                                   | Mapweight 1 = SNP aligns exactly at one locus            |
-- | Mapweight 2 = Mapped to single position in genome                        | Mapweight 2 = SNP aligns at two locus on same chromosome |
-- | Mapweight 3 = Mapped to 2 positions on a single chromosome               | Mapweight 3 = SNP aligns at less than 10 locus           |
-- | Mapweight 4 = Mapped to 3-10 positions in genome (possible paralog hits) |                                                          |
-- | Mapweight 5 = Mapped to >10 positions in genome                          | Mapweight 10= SNP aligns at more than 10 locations       |
--
-- The mapweight definitions for the database are different for historical reasons, so both definition series are correct: The
-- mapweights defined in the chromosome reports section of the FTP README are true for chromosome reports, and the
-- definitions given for the database tables in the database dictionary are true for all FTP data table files. (07/14/08)
--
-- Ref: http://www.ncbi.nlm.nih.gov/books/NBK44455/#Build.Mapping_Weight
