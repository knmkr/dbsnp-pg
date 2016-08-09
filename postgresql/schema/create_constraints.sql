-- ftp.ncbi.nih.gov:/snp/database/shared_schema/dbSNP_main_index.sql.gz
--                                             /dbSNP_main_constraint.sql.gz

-- CREATE NONCLUSTERED INDEX [i_rev_allele_id] ON [Allele] ([rev_allele_id] ASC)
-- CREATE CLUSTERED INDEX [i_code] ON [SnpValidationCode] ([code] ASC)
--
-- ALTER TABLE [Allele] ADD CONSTRAINT [df_Allele_create_time] DEFAULT (GETDATE()) FOR [create_time]
-- ALTER TABLE [Allele] ADD CONSTRAINT [df_Allele_update_time] DEFAULT (GETDATE()) FOR [last_updated_time]
-- ALTER TABLE [Allele] ADD CONSTRAINT [pk_Allele]  PRIMARY KEY  CLUSTERED ([allele_id] ASC)
-- ALTER TABLE [SnpClassCode] ADD CONSTRAINT [pk_SnpClassCode]  PRIMARY KEY  CLUSTERED ([code] ASC)
-- ALTER TABLE [SnpValidationCode] ADD CONSTRAINT [pk_SnpValidationCode]  PRIMARY KEY  NONCLUSTERED ([code] ASC)

CREATE INDEX i_rev_allele_id ON Allele (rev_allele_id);
CREATE INDEX i_code ON SnpValidationCode (code);

CLUSTER SnpValidationCode USING i_code;
ALTER TABLE Allele ADD PRIMARY KEY (allele_id);
CLUSTER Allele USING allele_pkey;
ALTER TABLE SnpClassCode ADD PRIMARY KEY (code);
CLUSTER SnpClassCode USING snpclasscode_pkey;
ALTER TABLE SnpValidationCode ADD PRIMARY KEY (code);

--
CREATE UNIQUE INDEX snpchrcode_ukey_code ON SnpChrCode (code);


-- ftp.ncbi.nih.gov:/snp/organisms/human_9606/database/organism_schema/human_9606_index.sql.gz
--                                                                    /human_9606_constraint.sql.gz
--
-- CREATE CLUSTERED INDEX [i_rsH] ON [RsMergeArch] ([rsHigh] ASC)
-- CREATE NONCLUSTERED INDEX [i_rsL] ON [RsMergeArch] ([rsLow] ASC)
-- CREATE CLUSTERED INDEX [i_rs] ON [SNP] ([snp_id] ASC)
-- CREATE CLUSTERED INDEX [i_rs_hgvs] ON [SNPClinSig] ([hgvs_g] ASC,[snp_id] ASC)
-- CREATE NONCLUSTERED INDEX [i_rs] ON [SNPVal] ([snp_id] ASC)
--
-- ALTER TABLE [BatchValCode] ADD CONSTRAINT [pk_BatchValCode]  PRIMARY KEY  CLUSTERED ([batch_id] ASC)
-- ALTER TABLE [ClinSigCode] ADD CONSTRAINT [DF__ClinSigCo__creat__5FBB8CD0] DEFAULT (GETDATE()) FOR [create_time]
-- ALTER TABLE [ClinSigCode] ADD CONSTRAINT [DF__ClinSigCo__last___60AFB109] DEFAULT (GETDATE()) FOR [last_updated_time]
-- ALTER TABLE [ClinSigCode] ADD CONSTRAINT [DF__ClinSigCo__sever__58B68DF4] DEFAULT ((0)) FOR [severity_level]
-- ALTER TABLE [ClinSigCode] ADD CONSTRAINT [PK__ClinSigC__357D4CF85DD3445E]  PRIMARY KEY  CLUSTERED ([code] ASC)
-- ALTER TABLE [SNPVal] ADD CONSTRAINT [pk_SNPVal]  PRIMARY KEY  CLUSTERED ([batch_id] ASC,[snp_id] ASC)

CREATE INDEX i_rsH ON RsMergeArch (rsHigh);
CLUSTER RsMergeArch USING i_rsH;
CREATE INDEX i_rsL ON RsMergeArch (rsLow);
CREATE INDEX i_rs ON SNP (snp_id);
CLUSTER SNP USING i_rs;
CREATE INDEX i_rs_hgvs ON SNPClinSig (hgvs_g, snp_id);
CLUSTER SNPClinSig USING i_rs_hgvs;
CREATE INDEX i_rs ON SNPVal (snp_id);

ALTER TABLE BatchValCode ADD PRIMARY KEY batch_id;
CLUSTER BatchValCode USING batchvalcode_pkey;
ALTER TABLE ClinSigCode ADD PRIMARY KEY code;
CLUSTER ClinSigCode USING clinsigcode_pkey;
ALTER TABLE SNPVal ADD PRIMARY KEY (batch_id, snp_id);
CLUSTER SNPVal USING snpval_pkey;

--
CREATE INDEX omimvar_snp_id ON OmimVarLocusIdSNP (snp_id);
CREATE INDEX snp3d_snp_id ON SNP3D (snp_id);
CREATE INDEX maplinkinfo_gi ON MapLinkInfo (gi);
CREATE INDEX maplink_snp_id ON MapLink (snp_id);
CREATE UNIQUE INDEX SNPChrPosOnRef_ukey_rs ON SNPChrPosOnRef (snp_id);
CREATE INDEX SNPChrPosOnRef_chr_pos ON SNPChrPosOnRef (chr, pos);
CREATE INDEX SNPContigLoc_rs_ctg ON SNPContigLoc (snp_id, ctg_id);  --  (snp_type, snp_id, ctg_id);
CREATE UNIQUE INDEX ContigInfo_ukey_ctg ON ContigInfo (ctg_id);
CREATE INDEX snp_bitfield_snp_id ON SNP_bitfield (snp_id);
