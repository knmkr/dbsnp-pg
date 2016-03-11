-- ftp.ncbi.nih.gov:/snp/database/shared_schema/dbSNP_main_index.sql.gz
--                                             /dbSNP_main_constraint.sql.gz

-- CREATE NONCLUSTERED INDEX [i_rev_allele_id] ON [Allele] ([rev_allele_id] ASC)
--
-- ALTER TABLE [Allele] ADD CONSTRAINT [df_Allele_create_time] DEFAULT (GETDATE()) FOR [create_time]
-- ALTER TABLE [Allele] ADD CONSTRAINT [df_Allele_update_time] DEFAULT (GETDATE()) FOR [last_updated_time]
-- ALTER TABLE [Allele] ADD CONSTRAINT [pk_Allele]  PRIMARY KEY  CLUSTERED ([allele_id] ASC)
CREATE INDEX i_rev_allele_id ON Allele (rev_allele_id);
ALTER TABLE Allele ADD PRIMARY KEY (allele_id);
CLUSTER Allele USING allele_pkey;

--
CREATE UNIQUE INDEX SnpChrCode_ukey_code ON SnpChrCode (code);


-- ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/organism_schema/human_9606_index.sql.gz
--                                                                    /human_9606_constraint.sql.gz

-- CREATE CLUSTERED INDEX [i_rsH] ON [RsMergeArch] ([rsHigh] ASC)
-- CREATE NONCLUSTERED INDEX [i_rsL] ON [RsMergeArch] ([rsLow] ASC)
-- CREATE CLUSTERED INDEX [i_rs] ON [SNP] ([snp_id] ASC)
CREATE INDEX i_rsH ON RsMergeArch (rsHigh);
CLUSTER RsMergeArch USING i_rsH;
CREATE INDEX i_rsL ON RsMergeArch (rsLow);
CREATE INDEX i_rs ON SNP (snp_id);
CLUSTER SNP USING i_rs;

--
CREATE UNIQUE INDEX SNPChrPosOnRef_ukey_rs ON SNPChrPosOnRef (snp_id);
CREATE INDEX SNPChrPosOnRef_chr_pos ON SNPChrPosOnRef (chr, pos);
CREATE INDEX SNPContigLoc_rs_ctg ON SNPContigLoc (snp_id, ctg_id);  --  (snp_type, snp_id, ctg_id);
CREATE UNIQUE INDEX ContigInfo_ukey_ctg ON ContigInfo (ctg_id);
