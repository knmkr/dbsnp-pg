CREATE TABLE [Allele]
(
[allele_id] [int] NOT NULL ,
[allele] [varchar](1024) NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[rev_allele_id] [int] NULL ,
[src] [varchar](10) NULL ,
[last_updated_time] [smalldatetime] NULL ,
[allele_left] [varchar](900) NULL ,
[allele_md5] [binary] NULL
)
go

CREATE TABLE [AlleleFlagCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](12) NOT NULL ,
[descrip] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [AlleleMotif]
(
[allele_id] [int] NOT NULL ,
[motif_order] [int] NOT NULL ,
[motif_id] [int] NOT NULL ,
[repeat_cnt] [real] NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [AllocIds]
(
[name] [varchar](30) NOT NULL ,
[id] [bigint] NOT NULL ,
[cycle] [int] NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL ,
[comment] [varchar](255) NULL
)
go

CREATE TABLE [Author]
(
[pub_id] [int] NOT NULL ,
[position] [tinyint] NOT NULL ,
[author] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [BatchAssertedPositionSourceId]
(
[pos_src_id] [int] NOT NULL ,
[pos_src_type_code] [int] NOT NULL ,
[pos_src_path] [varchar](255) NULL ,
[pos_src_note] [varchar](255) NULL ,
[insert_time] [smalldatetime] NULL
)
go

CREATE TABLE [Batch_tax_id]
(
[batch_id] [int] NOT NULL ,
[tax_id] [int] NOT NULL ,
[update_time] [datetime] NOT NULL ,
[asm_acc] [varchar](32) NULL ,
[asm_version] [smallint] NULL ,
[pos_src_id] [int] NULL ,
[comment] [varchar](255) NULL
)
go

CREATE TABLE [ChiSqPValueLookUp]
(
[df] [tinyint] NOT NULL ,
[chisq_from] [float] NOT NULL ,
[chisq_to] [float] NOT NULL ,
[pvalue_upper_bound] [float] NOT NULL
)
go

CREATE TABLE [CpGCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](12) NOT NULL ,
[descrip] [varchar](255) NOT NULL
)
go

CREATE TABLE [GenBankDivisionCode]
(
[code] [varchar](6) NOT NULL ,
[abbrev] [varchar](40) NOT NULL ,
[descrip] [varchar](255) NOT NULL ,
[display_order] [tinyint] NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [GenderCode]
(
[code] [char](1) NOT NULL ,
[gender] [varchar](6) NOT NULL
)
go

CREATE TABLE [GtyAllele]
(
[gty_id] [int] NOT NULL ,
[rev_flag] [bit] NOT NULL ,
[chr_num] [tinyint] NOT NULL ,
[fwd_allele_id] [int] NOT NULL ,
[unigty_id] [int] NULL ,
[create_time] [smalldatetime] NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [IUPACna]
(
[allele] [varchar](1) NOT NULL ,
[meaning] [varchar](10) NOT NULL ,
[bitcode] [varchar](4) NOT NULL ,
[value] [tinyint] NOT NULL ,
[rev_base] [char](1) NULL
)
go

CREATE TABLE [LoadHistory]
(
[build_id] [int] NOT NULL ,
[loaddate] [smalldatetime] NOT NULL ,
[status] [char](30) NOT NULL ,
[comments] [varchar](255) NULL ,
[script] [varchar](255) NULL ,
[ftp_done_date] [smalldatetime] NULL ,
[entrez_done_date] [smalldatetime] NULL ,
[blastdb_done_date] [smalldatetime] NULL ,
[web_date] [smalldatetime] NULL
)
go

CREATE TABLE [LocTypeCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](12) NOT NULL ,
[descrip] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [MapLinkCode]
(
[which_code] [varchar](20) NOT NULL ,
[code] [tinyint] NOT NULL ,
[abbr] [varchar](10) NULL ,
[note] [varchar](255) NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [Method]
(
[method_id] [int] NOT NULL ,
[handle] [varchar](20) NOT NULL ,
[loc_method_id] [varchar](64) NOT NULL ,
[loc_method_id_upp] [varchar](64) NOT NULL ,
[method_class] [tinyint] NULL ,
[template_type] [tinyint] NULL ,
[seq_both_strands] [varchar](3) NULL ,
[mult_pcr_amplification] [varchar](3) NULL ,
[mult_clones_tested] [varchar](3) NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [MethodClass]
(
[meth_class_id] [tinyint] NOT NULL ,
[name] [varchar](64) NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL ,
[validation_status] [tinyint] NOT NULL
)
go

CREATE TABLE [MethodLine]
(
[method_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [Moltype]
(
[code] [tinyint] NOT NULL ,
[moltype] [varchar](10) NOT NULL ,
[descrip] [varchar](255) NOT NULL
)
go

CREATE TABLE [Motif]
(
[motif_id] [int] NOT NULL ,
[motif] [varchar](1024) NOT NULL ,
[rev_motif_id] [int] NULL ,
[last_updated_time] [smalldatetime] NULL ,
[motif_left] [varchar](900) NULL
)
go

CREATE TABLE [ObsGenotype]
(
[gty_id] [int] NOT NULL ,
[obs] [varchar](512) NOT NULL ,
[obs_upp_fix] [varchar](512) NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [ObsVariation]
(
[var_id] [int] NOT NULL ,
[pattern] [varchar](1024) NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[last_updated_time] [smalldatetime] NULL ,
[univar_id] [int] NULL ,
[var_flag] [tinyint] NULL ,
[pattern_left] [varchar](900) NULL
)
go

CREATE TABLE [OrgDbStatus]
(
[database_name] [varchar](32) NOT NULL ,
[SNP_cnt] [int] NULL ,
[SubSNP_cnt] [int] NULL ,
[cluster_cnt] [int] NULL ,
[unmapped_rs_cnt] [int] NULL ,
[SubInd_cnt] [int] NULL ,
[ind_cnt] [int] NULL ,
[SubInd_ss_cnt] [int] NULL ,
[SubPop_cnt] [int] NULL ,
[pop_cnt] [int] NULL ,
[SubPop_ss_cnt] [int] NULL ,
[GtyFreqBySsPop_ss_cnt] [int] NULL ,
[AlleleFreqBySsPop_ss_cnt] [int] NULL ,
[SNPGtyFreq_rs_cnt] [int] NULL ,
[SNPAlleleFreq_rs_cnt] [int] NULL ,
[snp_build_max] [int] NULL ,
[genome_build_max] [varchar](8) NULL ,
[map_time] [smalldatetime] NULL ,
[cluster_time_max] [smalldatetime] NULL ,
[create_time] [smalldatetime] NULL ,
[last_SNPBatch_time] [smalldatetime] NULL ,
[last_POPBatch_time] [smalldatetime] NULL ,
[last_INDBatch_time] [smalldatetime] NULL ,
[rsMax] [int] NULL ,
[rsMissenseMax] [int] NULL ,
[copy2FTP_time] [smalldatetime] NULL
)
go

CREATE TABLE [OrganismTax]
(
[organism] [varchar](128) NOT NULL ,
[tax_id] [int] NOT NULL ,
[common_name] [varchar](36) NULL ,
[gpipe_abbr] [varchar](7) NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL ,
[comment] [varchar](255) NULL ,
[division_cd] [varchar](6) NULL ,
[database_name] [varchar](32) NOT NULL ,
[short_common_name] [varchar](32) NOT NULL ,
[tax_id_rank] [varchar](6) NOT NULL ,
[species_tax_id] [int] NOT NULL ,
[no_freq_summary] [bit] NULL ,
[entrez_index] [smallint] NULL ,
[pub_genome_build] [decimal] NULL ,
[pub_build_id] [int] NULL
)
go

CREATE TABLE [PopClass]
(
[pop_id] [int] NOT NULL ,
[pop_class_id] [int] NOT NULL ,
[snp_count] [int] NULL
)
go

CREATE TABLE [PopClassCode]
(
[pop_class_id] [int] NOT NULL ,
[pop_class] [char](50) NOT NULL ,
[pop_class_text] [char](255) NOT NULL
)
go

CREATE TABLE [Publication]
(
[pub_id] [int] NOT NULL ,
[pmid] [int] NULL ,
[handle] [varchar](20) NOT NULL ,
[meduid] [int] NULL ,
[title] [varchar](235) NOT NULL ,
[journal] [varchar](255) NULL ,
[vol] [varchar](255) NULL ,
[suppl] [varchar](128) NULL ,
[issue] [varchar](128) NULL ,
[i_suppl] [varchar](128) NULL ,
[pages] [varchar](255) NULL ,
[year] [smallint] NOT NULL ,
[status] [tinyint] NOT NULL ,
[blobflag] [tinyint] NULL ,
[last_updated] [smalldatetime] NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [SNPGlossary]
(
[term] [varchar](256) NOT NULL ,
[description] [varchar](4000) NULL ,
[last_updated] [smalldatetime] NULL ,
[used_in] [varchar](32) NULL
)
go

CREATE TABLE [SNP_tax_id]
(
[snp_id] [int] NOT NULL ,
[tax_id] [int] NULL ,
[update_time] [smalldatetime] NULL ,
[status] [char](1) NULL
)
go

CREATE TABLE [SnpChrCode]
(
[code] [varchar](8) NOT NULL ,
[abbrev] [varchar](20) NOT NULL ,
[descrip] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[sort_order] [tinyint] NULL ,
[db_name] [varchar](32) NULL ,
[NC_acc] [varchar](16) NULL
)
go

CREATE TABLE [SnpClassCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](20) NOT NULL ,
[descrip] [varchar](255) NOT NULL ,
[display_str] [varchar](255) NULL
)
go

CREATE TABLE [SnpFunctionCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](20) NOT NULL ,
[descrip] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[top_level_class] [char](5) NOT NULL ,
[is_coding] [tinyint] NOT NULL ,
[is_exon] [bit] NULL ,
[var_prop_effect_code] [int] NULL ,
[var_prop_gene_loc_code] [int] NULL ,
[SO_id] [varchar](32) NULL
)
go

CREATE TABLE [SnpValidationCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](64) NOT NULL ,
[descrip] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [StrandCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](20) NOT NULL ,
[rs_to_ss_orien] [bit] NOT NULL ,
[descrip] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [SubSNPAssertedPositionSourceCode]
(
[code] [int] NOT NULL ,
[abbrev] [varchar](32) NULL ,
[descrip] [varchar](2000) NULL ,
[create_time] [smalldatetime] NULL
)
go

CREATE TABLE [SubSNPDelComm]
(
[comment_id] [smallint] NOT NULL ,
[comment] [varchar](400) NULL ,
[create_time] [smalldatetime] NULL
)
go

CREATE TABLE [SubSNPSeqTypeCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](20) NOT NULL ,
[descrip] [varchar](255) NOT NULL
)
go

CREATE TABLE [Submitter]
(
[handle] [varchar](20) NOT NULL ,
[name] [varchar](255) NOT NULL ,
[fax] [varchar](255) NULL ,
[phone] [varchar](255) NULL ,
[email] [varchar](255) NULL ,
[lab] [varchar](255) NULL ,
[institution] [varchar](255) NULL ,
[address] [varchar](255) NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [TemplateType]
(
[temp_type_id] [tinyint] NOT NULL ,
[name] [varchar](64) NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [UniGty]
(
[unigty_id] [int] NOT NULL ,
[gty_str] [varchar](255) NULL ,
[allele_id_1] [int] NOT NULL ,
[allele_id_2] [int] NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [UniVariAllele]
(
[univar_id] [int] NOT NULL ,
[allele_id] [int] NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [UniVariation]
(
[univar_id] [int] NOT NULL ,
[var_str] [varchar](1024) NULL ,
[allele_cnt] [smallint] NOT NULL ,
[subsnp_class] [tinyint] NOT NULL ,
[iupack_code] [char](1) NOT NULL ,
[top_or_bot_strand] [char](1) NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL ,
[src_code] [tinyint] NULL ,
[rev_univar_id] [int] NULL ,
[var_str_left] [varchar](900) NULL
)
go

CREATE TABLE [UniVariationSrcCode]
(
[code] [tinyint] NOT NULL ,
[abbrev] [varchar](20) NOT NULL ,
[descrip] [varchar](255) NOT NULL
)
go

CREATE TABLE [VariAllele]
(
[var_id] [int] NOT NULL ,
[allele_id] [int] NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [db_ftp_table_list]
(
[table_name] [varchar](32) NOT NULL ,
[db_str] [varchar](64) NOT NULL ,
[create_time] [smalldatetime] NULL
)
go

CREATE TABLE [db_map_table_name]
(
[table_name] [varchar](32) NOT NULL ,
[to_index] [bit] NULL ,
[isCurrent] [char](1) NULL ,
[inHuman] [char](1) NULL ,
[inNonHuman] [char](1) NOT NULL ,
[inFtpDump] [bit] NULL
)
go

CREATE TABLE [dn_Allele_rev]
(
[allele_id] [int] NOT NULL ,
[rev_flag] [tinyint] NOT NULL ,
[fwd_allele_id] [int] NOT NULL ,
[fwd_allele] [varchar](1024) NOT NULL
)
go

CREATE TABLE [dn_Motif_rev]
(
[motif_id] [int] NOT NULL ,
[rev_flag] [tinyint] NOT NULL ,
[fwd_motif] [varchar](1024) NULL ,
[fwd_motif_id] [int] NULL
)
go

CREATE TABLE [dn_UniGty_allele]
(
[unigty_id] [int] NOT NULL ,
[chr_num] [tinyint] NOT NULL ,
[allele_id] [int] NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [dn_UniGty_rev]
(
[unigty_id] [int] NOT NULL ,
[rev_flag] [tinyint] NOT NULL ,
[fwd_unigty_id] [int] NOT NULL ,
[fwd_gty_str] [varchar](255) NULL
)
go

CREATE TABLE [dn_UniVariation_rev]
(
[univar_id] [int] NOT NULL ,
[rev_flag] [tinyint] NOT NULL ,
[fwd_univar_id] [int] NULL ,
[fwd_univar_str] [varchar](900) NULL
)
go

CREATE TABLE [dn_baseFlip]
(
[base] [char](1) NULL ,
[rev_flag] [tinyint] NULL ,
[fwd_base] [char](1) NULL
)
go

CREATE TABLE [dn_gty2unigty_trueSNP]
(
[gty_id] [int] NOT NULL ,
[rev_flag] [bit] NOT NULL ,
[unigty_id] [int] NULL ,
[obs] [varchar](512) NOT NULL ,
[gty_str] [varchar](255) NULL
)
go

CREATE TABLE [dn_summary]
(
[tax_id] [int] NOT NULL ,
[build_id] [int] NOT NULL ,
[type] [varchar](20) NOT NULL ,
[cnt] [int] NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL
)
go

