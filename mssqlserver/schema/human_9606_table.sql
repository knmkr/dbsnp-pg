CREATE TABLE [AlleleFreqBySsPop]
(
[subsnp_id] [int] NOT NULL ,
[pop_id] [int] NOT NULL ,
[allele_id] [int] NOT NULL ,
[source] [varchar](2) NOT NULL ,
[cnt] [real] NULL ,
[freq] [real] NULL ,
[last_updated_time] [datetime] NOT NULL
)
go

CREATE TABLE [Batch]
(
[batch_id] [int] NOT NULL ,
[handle] [varchar](20) NOT NULL ,
[loc_batch_id] [varchar](64) NOT NULL ,
[loc_batch_id_upp] [varchar](64) NOT NULL ,
[batch_type] [char](3) NOT NULL ,
[status] [tinyint] NULL ,
[simul_sts_status] [tinyint] NOT NULL ,
[moltype] [varchar](8) NOT NULL ,
[method_id] [int] NOT NULL ,
[samplesize] [int] NULL ,
[synonym_type] [varchar](255) NULL ,
[submitted_time] [smalldatetime] NOT NULL ,
[linkout_url] [varchar](255) NULL ,
[pop_id] [int] NULL ,
[last_updated_time] [smalldatetime] NULL ,
[success_rate_int] [int] NULL ,
[build_id] [int] NULL ,
[tax_id] [int] NOT NULL ,
[ss_cnt] [int] NULL
)
go

CREATE TABLE [BatchCita]
(
[batch_id] [int] NOT NULL ,
[position] [int] NOT NULL ,
[pub_id] [int] NOT NULL ,
[citation] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [BatchCommLine]
(
[batch_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [BatchCultivar]
(
[batch_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [BatchMeExLine]
(
[batch_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [BatchStrain]
(
[batch_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [BatchValCode]
(
[batch_id] [int] NOT NULL ,
[validation_status] [tinyint] NOT NULL
)
go

CREATE TABLE [ClinSigCode]
(
[code] [int] NOT NULL ,
[abbrev] [varchar](64) NULL ,
[descrip] [varchar](255) NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL ,
[severity_level] [tinyint] NOT NULL
)
go

CREATE TABLE [Contact]
(
[batch_id] [int] NOT NULL ,
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

CREATE TABLE [FreqSummaryBySsPop]
(
[subsnp_id] [int] NOT NULL ,
[pop_id] [int] NOT NULL ,
[source] [varchar](1) NOT NULL ,
[chr_cnt] [float] NULL ,
[ind_cnt] [float] NULL ,
[non_founder_ind_cnt] [int] NOT NULL ,
[chisq] [float] NULL ,
[df] [int] NULL ,
[hwp] [float] NOT NULL ,
[het] [int] NULL ,
[het_se] [int] NULL ,
[last_updated_time] [datetime] NOT NULL
)
go

CREATE TABLE [GeneIdToName]
(
[gene_id] [int] NOT NULL ,
[gene_symbol] [varchar](64) NOT NULL ,
[gene_name] [varchar](255) NULL ,
[gene_type] [varchar](255) NULL ,
[tax_id] [int] NOT NULL ,
[last_update_time] [smalldatetime] NOT NULL ,
[ref_tax_id] [int] NOT NULL ,
[dbSNP_tax_id] [int] NOT NULL ,
[ins_time] [smalldatetime] NULL
)
go

CREATE TABLE [GtyFreqBySsPop]
(
[subsnp_id] [int] NOT NULL ,
[pop_id] [int] NOT NULL ,
[unigty_id] [int] NOT NULL ,
[source] [varchar](1) NULL ,
[cnt] [real] NULL ,
[freq] [real] NULL ,
[last_updated_time] [datetime] NOT NULL
)
go

CREATE TABLE [IndGrpCode]
(
[code] [tinyint] NOT NULL ,
[name] [varchar](32) NOT NULL ,
[descrip] [varchar](255) NOT NULL
)
go

CREATE TABLE [IndivBySource]
(
[ind_id] [int] NOT NULL ,
[src_id] [int] NOT NULL ,
[src_ind_id] [varchar](64) NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[src_ind_grp] [varchar](64) NULL
)
go

CREATE TABLE [IndivSourceCode]
(
[code] [int] NOT NULL ,
[name] [varchar](22) NOT NULL ,
[descrip] [varchar](255) NULL ,
[create_time] [smalldatetime] NOT NULL ,
[src_type] [varchar](10) NULL ,
[display_order] [tinyint] NULL
)
go

CREATE TABLE [Individual]
(
[ind_id] [int] NOT NULL ,
[descrip] [varchar](255) NULL ,
[create_time] [smalldatetime] NOT NULL ,
[tax_id] [int] NULL ,
[ind_grp] [tinyint] NULL
)
go

CREATE TABLE [OmimVarLocusIdSNP]
(
[omim_id] [int] NOT NULL ,
[locus_id] [int] NULL ,
[omimvar_id] [char](4) NULL ,
[locus_symbol] [char](10) NULL ,
[var1] [char](20) NULL ,
[aa_position] [int] NULL ,
[var2] [char](20) NULL ,
[var_class] [int] NOT NULL ,
[snp_id] [int] NOT NULL
)
go

CREATE TABLE [Pedigree]
(
[ped_id] [numeric] NOT NULL ,
[curator] [varchar](12) NOT NULL ,
[curator_ped_id] [varchar](12) NOT NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [PedigreeIndividual]
(
[ped_id] [decimal] NOT NULL ,
[ind_id] [int] NOT NULL ,
[ma_ind_id] [int] NULL ,
[pa_ind_id] [int] NULL ,
[sex] [char](1) NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [PopLine]
(
[pop_id] [int] NOT NULL ,
[line_num] [int] NOT NULL ,
[line] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [PopMandLine]
(
[pop_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [Population]
(
[pop_id] [int] NOT NULL ,
[handle] [varchar](20) NOT NULL ,
[loc_pop_id] [varchar](64) NOT NULL ,
[loc_pop_id_upp] [varchar](64) NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL ,
[src_id] [int] NULL
)
go

CREATE TABLE [RsMergeArch]
(
[rsHigh] [int] NOT NULL ,
[rsLow] [int] NOT NULL ,
[build_id] [int] NULL ,
[orien] [tinyint] NOT NULL ,
[create_time] [datetime] NOT NULL ,
[last_updated_time] [datetime] NOT NULL ,
[rsCurrent] [int] NULL ,
[orien2Current] [tinyint] NULL ,
[comment] [varchar](255) NULL
)
go

CREATE TABLE [SNP]
(
[snp_id] [int] NULL ,
[avg_heterozygosity] [real] NULL ,
[het_se] [real] NULL ,
[create_time] [datetime] NULL ,
[last_updated_time] [datetime] NULL ,
[CpG_code] [tinyint] NULL ,
[tax_id] [int] NULL ,
[validation_status] [tinyint] NULL ,
[exemplar_subsnp_id] [int] NOT NULL ,
[univar_id] [int] NULL ,
[cnt_subsnp] [int] NULL ,
[map_property] [tinyint] NULL
)
go

CREATE TABLE [SNP3D]
(
[snp_id] [int] NOT NULL ,
[protein_acc] [char](50) NOT NULL ,
[master_gi] [int] NOT NULL ,
[neighbor_gi] [int] NOT NULL ,
[aa_position] [int] NOT NULL ,
[var_res] [char](100) NOT NULL ,
[contig_res] [char](3) NOT NULL ,
[neighbor_res] [char](3) NOT NULL ,
[neighbor_pos] [int] NOT NULL ,
[var_color] [int] NOT NULL ,
[var_label] [int] NOT NULL
)
go

CREATE TABLE [SNPAlleleFreq]
(
[snp_id] [int] NOT NULL ,
[allele_id] [int] NOT NULL ,
[chr_cnt] [float] NULL ,
[freq] [float] NULL ,
[last_updated_time] [datetime] NOT NULL
)
go

CREATE TABLE [SNPAlleleFreq_ESP]
(
[snp_id] [int] NULL ,
[allele_id] [int] NOT NULL ,
[freq] [float] NULL ,
[count] [int] NULL ,
[is_minor_allele] [int] NULL
)
go

CREATE TABLE [SNPAlleleFreq_ExAC]
(
[snp_id] [int] NULL ,
[allele_id] [int] NOT NULL ,
[freq] [float] NULL ,
[count] [int] NULL ,
[is_minor_allele] [int] NULL
)
go

CREATE TABLE [SNPAlleleFreq_TGP]
(
[snp_id] [int] NULL ,
[allele_id] [int] NOT NULL ,
[freq] [float] NULL ,
[count] [int] NULL ,
[is_minor_allele] [int] NULL
)
go

CREATE TABLE [SNPAncestralAllele]
(
[snp_id] [int] NOT NULL ,
[ancestral_allele_id] [int] NOT NULL ,
[batch_id] [int] NOT NULL
)
go

CREATE TABLE [SNPClinSig]
(
[hgvs_g] [varchar](255) NULL ,
[snp_id] [int] NULL ,
[tested] [char](1) NULL ,
[clin_sig_id] [int] NOT NULL ,
[upd_time] [datetime] NOT NULL ,
[clin_sig_id_by_rs] [int] NOT NULL
)
go

CREATE TABLE [SNPGtyFreq]
(
[snp_id] [int] NOT NULL ,
[unigty_id] [int] NOT NULL ,
[ind_cnt] [float] NULL ,
[freq] [float] NULL ,
[last_updated_time] [datetime] NOT NULL
)
go

CREATE TABLE [SNPHWProb]
(
[snp_id] [int] NOT NULL ,
[df] [tinyint] NULL ,
[chisq] [real] NULL ,
[hwp] [real] NULL ,
[ind_cnt] [smallint] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [SNPHistory]
(
[snp_id] [int] NOT NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NOT NULL ,
[history_create_time] [smalldatetime] NULL ,
[comment] [varchar](255) NULL ,
[reactivated_time] [smalldatetime] NULL
)
go

CREATE TABLE [SNPPubmed]
(
[snp_id] [int] NULL ,
[subsnp_id] [int] NULL ,
[pubmed_id] [int] NULL ,
[type] [varchar](16) NULL ,
[score] [int] NOT NULL ,
[upd_time] [datetime] NOT NULL
)
go

CREATE TABLE [SNPSubSNPLink]
(
[subsnp_id] [int] NULL ,
[snp_id] [int] NULL ,
[substrand_reversed_flag] [tinyint] NULL ,
[create_time] [datetime] NULL ,
[last_updated_time] [datetime] NULL ,
[build_id] [int] NULL ,
[comment] [varchar](255) NULL
)
go

CREATE TABLE [SNPSubSNPLinkHistory]
(
[subsnp_id] [int] NULL ,
[snp_id] [int] NULL ,
[build_id] [int] NULL ,
[history_create_time] [datetime] NOT NULL ,
[link_create_time] [datetime] NULL ,
[link_last_updated_time] [datetime] NULL ,
[orien] [tinyint] NULL ,
[build_id_when_history_made] [int] NULL ,
[comment] [varchar](255) NULL
)
go

CREATE TABLE [SNPSuspect]
(
[snp_id] [int] NOT NULL ,
[reason_code] [int] NULL ,
[upd_time] [smalldatetime] NULL
)
go

CREATE TABLE [SNPVal]
(
[batch_id] [int] NOT NULL ,
[snp_id] [int] NOT NULL
)
go

CREATE TABLE [SNP_HGVS]
(
[hgvs_name] [varchar](300) NULL ,
[snp_id] [int] NULL
)
go

CREATE TABLE [SNP_bitfield]
(
[snp_id] [int] NOT NULL ,
[ver_code] [tinyint] NULL ,
[link_prop_b1] [tinyint] NULL ,
[link_prop_b2] [tinyint] NULL ,
[gene_prop_b1] [tinyint] NULL ,
[gene_prop_b2] [tinyint] NULL ,
[map_prop] [tinyint] NULL ,
[freq_prop] [tinyint] NULL ,
[gty_prop] [tinyint] NULL ,
[hapmap_prop] [tinyint] NULL ,
[pheno_prop] [tinyint] NULL ,
[variation_class] [tinyint] NOT NULL ,
[quality_check] [tinyint] NULL ,
[upd_time] [datetime] NOT NULL ,
[encoding] [binary] NULL
)
go

CREATE TABLE [SubPop]
(
[batch_id] [int] NOT NULL ,
[subsnp_id] [int] NOT NULL ,
[pop_id] [int] NOT NULL ,
[type] [char](3) NOT NULL ,
[samplesize] [int] NOT NULL ,
[submitted_strand_code] [tinyint] NULL ,
[submitted_rs] [int] NULL ,
[allele_flag] [tinyint] NULL ,
[ambiguity_status] [tinyint] NULL ,
[sub_heterozygosity] [real] NULL ,
[est_heterozygosity] [real] NULL ,
[est_het_se_sq] [real] NULL ,
[last_updated_time] [smalldatetime] NOT NULL ,
[observed] [varchar](1000) NULL ,
[sub_het_se_sq] [real] NULL ,
[subpop_id] [int] IDENTITY(1,1) NOT NULL
)
go

CREATE TABLE [SubPopAllele]
(
[batch_id] [int] NOT NULL ,
[subsnp_id] [int] NOT NULL ,
[pop_id] [int] NOT NULL ,
[allele] [char](1) NOT NULL ,
[other] [varchar](255) NULL ,
[freq] [real] NULL ,
[cnt_int] [int] NULL ,
[freq_min] [real] NULL ,
[freq_max] [real] NULL ,
[data_src] [varchar](6) NULL ,
[type] [char](3) NULL ,
[last_updated_time] [smalldatetime] NULL ,
[allele_flag] [tinyint] NULL ,
[cnt] [real] NULL ,
[allele_id] [int] NULL ,
[subpop_id] [int] NOT NULL
)
go

CREATE TABLE [SubPopGty]
(
[subpop_id] [int] NOT NULL ,
[gty_id] [int] NOT NULL ,
[gty_str] [varchar](255) NULL ,
[cnt] [real] NULL ,
[freq] [real] NULL ,
[last_updated_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [SubSNP]
(
[subsnp_id] [int] NOT NULL ,
[known_snp_handle] [varchar](20) NULL ,
[known_snp_loc_id] [varchar](64) NULL ,
[known_snp_loc_id_upp] [varchar](64) NULL ,
[batch_id] [int] NOT NULL ,
[loc_snp_id] [varchar](64) NULL ,
[loc_snp_id_upp] [varchar](64) NULL ,
[synonym_names] [varchar](255) NULL ,
[loc_sts_id] [varchar](64) NULL ,
[loc_sts_id_upp] [varchar](64) NULL ,
[segregate] [char](1) NOT NULL ,
[indiv_homozygosity_detected] [char](1) NULL ,
[PCR_confirmed_ind] [char](1) NULL ,
[gene_name] [varchar](64) NULL ,
[sequence_len] [int] NULL ,
[samplesize] [int] NULL ,
[EXPRESSED_SEQUENCE_ind] [char](1) NULL ,
[SOMATIC_ind] [char](1) NULL ,
[sub_locus_id] [int] NULL ,
[create_time] [smalldatetime] NULL ,
[last_updated_time] [smalldatetime] NULL ,
[ancestral_allele] [varchar](255) NULL ,
[CpG_code] [tinyint] NULL ,
[variation_id] [int] NULL ,
[top_or_bot_strand] [char](1) NULL ,
[validation_status] [tinyint] NULL ,
[snp_id] [int] NULL ,
[tax_id] [int] NOT NULL ,
[chr_id] [tinyint] NULL
)
go

CREATE TABLE [SubSNPAcc_ins]
(
[subsnp_id] [int] NOT NULL ,
[acc_type_ind] [char](1) NOT NULL ,
[acc_part] [varchar](16) NOT NULL ,
[acc_ver] [int] NULL
)
go

CREATE TABLE [SubSNPCommLine_ins]
(
[subsnp_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL
)
go

CREATE TABLE [SubSNPHGVS]
(
[subsnp_id] [int] NOT NULL ,
[sub_hgvs_c] [varchar](255) NULL ,
[sub_hgvs_g] [varchar](255) NULL ,
[sub_hgvs_p] [varchar](255) NULL ,
[cal_hgvs_c] [varchar](255) NULL ,
[cal_hgvs_g] [varchar](255) NULL ,
[cal_hgvs_p] [varchar](255) NULL ,
[upd_time] [smalldatetime] NULL ,
[gene_id] [int] NULL
)
go

CREATE TABLE [SubSNPLinkout]
(
[subsnp_id] [int] NOT NULL ,
[url_val] [varchar](255) NOT NULL ,
[updated_time] [smalldatetime] NULL ,
[link_type] [varchar](3) NOT NULL
)
go

CREATE TABLE [SubSNPMdFailLn]
(
[subsnp_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL
)
go

CREATE TABLE [SubSNPNoVariSeq]
(
[subsnp_id] [int] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL
)
go

CREATE TABLE [SubSNPOmim]
(
[subsnp_id] [int] NOT NULL ,
[omim_id] [varchar](128) NULL ,
[allele_variant_id] [varchar](128) NULL ,
[update_time] [datetime] NULL ,
[mutObsCount] [int] NULL
)
go

CREATE TABLE [SubSNPPubmed]
(
[subsnp_id] [int] NOT NULL ,
[line_num] [int] NOT NULL ,
[pubmed_id] [int] NOT NULL ,
[updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [SubSNPSeq3_ins]
(
[subsnp_id] [int] NOT NULL ,
[type] [tinyint] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL
)
go

CREATE TABLE [SubSNPSeq5_ins]
(
[subsnp_id] [int] NOT NULL ,
[type] [tinyint] NOT NULL ,
[line_num] [tinyint] NOT NULL ,
[line] [varchar](255) NOT NULL
)
go

CREATE TABLE [SubSNPSeqPos]
(
[subsnp_id] [int] NOT NULL ,
[contig_acc] [varchar](20) NOT NULL ,
[contig_pos] [int] NOT NULL ,
[chr] [varchar](2) NULL ,
[upstream_len] [int] NOT NULL ,
[downstream_len] [int] NOT NULL ,
[last_update_time] [smalldatetime] NOT NULL ,
[mrna_acc] [varchar](24) NULL
)
go

CREATE TABLE [SubSNP_top_or_bot]
(
[subsnp_id] [int] NOT NULL ,
[top_or_bot] [char](1) NULL ,
[step] [tinyint] NULL ,
[last_updated_time] [smalldatetime] NULL
)
go

CREATE TABLE [SubmittedIndividual]
(
[submitted_ind_id] [int] NOT NULL ,
[pop_id] [int] NOT NULL ,
[loc_ind_id_upp] [varchar](64) NOT NULL ,
[ind_id] [int] NULL ,
[create_time] [smalldatetime] NOT NULL ,
[last_updated_time] [smalldatetime] NULL ,
[tax_id] [int] NOT NULL ,
[loc_ind_alias] [varchar](64) NULL ,
[loc_ind_id] [varchar](64) NULL ,
[loc_ind_grp] [varchar](64) NULL ,
[ploidy] [tinyint] NULL
)
go

CREATE TABLE [SuspectReasonCode]
(
[code] [int] NOT NULL ,
[abbrev] [varchar](64) NULL ,
[descrip] [varchar](255) NULL ,
[create_time] [smalldatetime] NULL ,
[last_update_time] [smalldatetime] NULL
)
go

CREATE TABLE [Synonym]
(
[subsnp_id] [int] NOT NULL ,
[type] [varchar](64) NOT NULL ,
[name] [varchar](64) NULL
)
go

CREATE TABLE [b149_ContigInfo_108]
(
[ctg_id] [bigint] NOT NULL ,
[tax_id] [int] NOT NULL ,
[contig_acc] [varchar](32) NOT NULL ,
[contig_ver] [smallint] NOT NULL ,
[contig_name] [varchar](63) NULL ,
[contig_chr] [varchar](32) NULL ,
[contig_start] [int] NULL ,
[contig_end] [int] NULL ,
[orient] [tinyint] NULL ,
[contig_gi] [bigint] NOT NULL ,
[group_term] [varchar](32) NULL ,
[group_label] [varchar](32) NULL ,
[contig_label] [varchar](32) NULL ,
[primary_fl] [tinyint] NOT NULL ,
[genbank_gi] [bigint] NULL ,
[genbank_acc] [varchar](32) NULL ,
[genbank_ver] [smallint] NULL ,
[build_id] [int] NOT NULL ,
[build_ver] [int] NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL ,
[placement_status] [tinyint] NOT NULL ,
[asm_acc] [varchar](32) NOT NULL ,
[asm_version] [smallint] NOT NULL ,
[chr_gi] [bigint] NULL ,
[par_fl] [tinyint] NULL ,
[top_level_fl] [tinyint] NOT NULL ,
[gen_rgn] [varchar](32) NULL ,
[contig_length] [int] NULL
)
go

CREATE TABLE [b149_MapLinkInfo_108]
(
[gi] [int] NOT NULL ,
[accession] [varchar](32) NOT NULL ,
[accession_ver] [smallint] NOT NULL ,
[acc] [varchar](32) NOT NULL ,
[version] [smallint] NOT NULL ,
[status] [varchar](32) NULL ,
[create_dt] [smalldatetime] NULL ,
[update_dt] [smalldatetime] NULL ,
[cds_from] [int] NULL ,
[cds_to] [int] NULL
)
go

CREATE TABLE [b149_MapLink_108]
(
[snp_type] [char](2) NULL ,
[snp_id] [int] NULL ,
[gi] [bigint] NULL ,
[accession_how_cd] [tinyint] NULL ,
[offset] [int] NULL ,
[asn_to] [int] NULL ,
[lf_ngbr] [int] NULL ,
[rf_ngbr] [int] NULL ,
[lc_ngbr] [int] NULL ,
[rc_ngbr] [int] NULL ,
[loc_type] [tinyint] NULL ,
[build_id] [int] NOT NULL ,
[process_time] [datetime] NULL ,
[process_status] [tinyint] NULL ,
[orientation] [tinyint] NULL ,
[allele] [varchar](1024) NULL ,
[aln_quality] [float] NULL ,
[num_mism] [int] NULL ,
[num_del] [int] NULL ,
[num_ins] [int] NULL ,
[tier] [int] NULL ,
[ctg_gi] [bigint] NULL ,
[ctg_from] [int] NULL ,
[ctg_to] [int] NULL ,
[ctg_orient] [tinyint] NULL ,
[source] [varchar](64) NULL
)
go

CREATE TABLE [b149_ProteinInfo_108]
(
[gi] [int] NOT NULL ,
[acc] [varchar](32) NOT NULL ,
[version] [smallint] NOT NULL ,
[prot_gi] [int] NOT NULL ,
[prot_acc] [varchar](32) NOT NULL ,
[prot_ver] [smallint] NOT NULL ,
[status] [varchar](32) NULL ,
[create_dt] [smalldatetime] NULL ,
[update_dt] [smalldatetime] NULL
)
go

CREATE TABLE [b149_SNPChrPosOnRef_108]
(
[snp_id] [int] NULL ,
[chr] [varchar](32) NULL ,
[pos] [int] NULL ,
[orien] [tinyint] NULL ,
[neighbor_snp_list] [int] NULL ,
[isPAR] [varchar](1) NULL
)
go

CREATE TABLE [b149_SNPContigLoc_108]
(
[snp_type] [varchar](2) NULL ,
[snp_id] [int] NULL ,
[ctg_id] [bigint] NULL ,
[asn_from] [int] NULL ,
[asn_to] [int] NULL ,
[lf_ngbr] [int] NULL ,
[rf_ngbr] [int] NULL ,
[lc_ngbr] [int] NULL ,
[rc_ngbr] [int] NULL ,
[loc_type] [tinyint] NULL ,
[phys_pos_from] [int] NULL ,
[snp_bld_id] [int] NOT NULL ,
[last_updated_time] [smalldatetime] NULL ,
[process_status] [tinyint] NULL ,
[orientation] [tinyint] NULL ,
[allele] [varchar](1024) NULL ,
[loc_sts_uid] [int] NULL ,
[aln_quality] [real] NULL ,
[num_mism] [int] NULL ,
[num_del] [int] NULL ,
[num_ins] [int] NULL ,
[tier] [tinyint] NULL
)
go

CREATE TABLE [b149_SNPContigLocusId_108]
(
[snp_id] [int] NULL ,
[contig_acc] [varchar](32) NOT NULL ,
[contig_ver] [tinyint] NULL ,
[asn_from] [int] NULL ,
[asn_to] [int] NULL ,
[locus_id] [int] NULL ,
[locus_symbol] [varchar](64) NULL ,
[mrna_acc] [varchar](32) NOT NULL ,
[mrna_ver] [smallint] NOT NULL ,
[protein_acc] [varchar](32) NULL ,
[protein_ver] [smallint] NULL ,
[fxn_class] [int] NULL ,
[reading_frame] [int] NULL ,
[allele] [varchar](1000) NULL ,
[residue] [varchar](341) NULL ,
[aa_position] [int] NULL ,
[build_id] [varchar](4) NOT NULL ,
[ctg_id] [bigint] NULL ,
[mrna_start] [int] NULL ,
[mrna_stop] [int] NULL ,
[codon] [varchar](1000) NULL ,
[protRes] [char](3) NULL ,
[contig_gi] [bigint] NULL ,
[mrna_gi] [bigint] NULL ,
[mrna_orien] [int] NULL ,
[cp_mrna_ver] [int] NULL ,
[cp_mrna_gi] [int] NULL ,
[verComp] [int] NULL
)
go

CREATE TABLE [b149_SNPMapInfo_108]
(
[snp_type] [varchar](2) NOT NULL ,
[snp_id] [int] NULL ,
[chr_cnt] [int] NOT NULL ,
[contig_cnt] [int] NOT NULL ,
[loc_cnt] [int] NOT NULL ,
[weight] [int] NOT NULL ,
[hap_cnt] [int] NULL ,
[placed_cnt] [int] NOT NULL ,
[unlocalized_cnt] [int] NOT NULL ,
[unplaced_cnt] [int] NOT NULL ,
[aligned_cnt] [int] NOT NULL ,
[md5] [char](32) NULL ,
[asm_acc] [varchar](32) NULL ,
[asm_version] [smallint] NULL ,
[assembly] [varchar](32) NULL
)
go

CREATE TABLE [b149_SNP_bitfield_108]
(
[snp_id] [int] NOT NULL ,
[ver_code] [tinyint] NULL ,
[link_prop_b1] [tinyint] NULL ,
[link_prop_b2] [tinyint] NULL ,
[gene_prop_b1] [tinyint] NULL ,
[gene_prop_b2] [tinyint] NULL ,
[map_prop] [tinyint] NULL ,
[freq_prop] [tinyint] NULL ,
[gty_prop] [tinyint] NULL ,
[hapmap_prop] [tinyint] NULL ,
[pheno_prop] [tinyint] NULL ,
[variation_class] [tinyint] NOT NULL ,
[quality_check] [tinyint] NULL ,
[upd_time] [datetime] NOT NULL ,
[encoding] [binary] NULL
)
go

CREATE TABLE [dn_IND_batchCount]
(
[batch_id] [int] NOT NULL ,
[pop_id] [int] NOT NULL ,
[ss_cnt] [int] NOT NULL ,
[rs_cnt] [int] NOT NULL ,
[ind_cnt] [int] NOT NULL ,
[create_time] [datetime] NOT NULL
)
go

CREATE TABLE [dn_IND_batch_pop]
(
[batch_id] [smallint] NOT NULL ,
[pop_id] [int] NOT NULL ,
[update_time] [datetime] NOT NULL
)
go

CREATE TABLE [dn_PopulationIndGrp]
(
[pop_id] [int] NOT NULL ,
[ind_grp_name] [varchar](32) NOT NULL ,
[ind_grp_code] [tinyint] NOT NULL
)
go

CREATE TABLE [dn_batchCount]
(
[batch_id] [int] NOT NULL ,
[ss_cnt] [int] NOT NULL ,
[rs_cnt] [int] NOT NULL ,
[rs_validated_cnt] [int] NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[pop_cnt] [int] NULL ,
[ind_cnt] [int] NULL
)
go

CREATE TABLE [dn_handleCount]
(
[handle] [varchar](20) NOT NULL ,
[batch_type] [char](3) NOT NULL ,
[ss_cnt] [int] NOT NULL ,
[rs_cnt] [int] NULL ,
[rs_validated_cnt] [int] NULL ,
[create_time] [smalldatetime] NOT NULL
)
go

CREATE TABLE [dn_snpFxnCnt]
(
[build_id] [int] NOT NULL ,
[fxn_class] [tinyint] NULL ,
[snp_cnt] [int] NOT NULL ,
[gene_cnt] [int] NOT NULL ,
[create_time] [smalldatetime] NOT NULL ,
[last_updated_time] [smalldatetime] NOT NULL ,
[tax_id] [int] NOT NULL
)
go

CREATE TABLE [dn_table_rowcount]
(
[tabname] [varchar](64) NOT NULL ,
[row_cnt] [int] NOT NULL ,
[build_id] [int] NOT NULL ,
[update_time] [datetime] NOT NULL ,
[rows_in_spaceused] [int] NULL ,
[reserved_KB_spaceused] [int] NULL ,
[data_KB_spaceused] [int] NULL ,
[index_size_KB_spaceused] [int] NULL ,
[unused_KB_spaceused] [int] NULL
)
go

