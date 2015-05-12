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
CREATE INDEX i_rsH ON RsMergeArch (rsHigh);
CLUSTER RsMergeArch USING i_rsH;
CREATE INDEX i_rsL ON RsMergeArch (rsLow);

--
CREATE UNIQUE INDEX SNPChrPosOnRef_ukey_rs ON SNPChrPosOnRef (snp_id);
CREATE INDEX SNPChrPosOnRef_chr_pos ON SNPChrPosOnRef (chr, pos);

-- CREATE NONCLUSTERED INDEX [i_handle_loc_pop_id_upp] ON [Population] ([handle] ASC,[loc_pop_id_upp] ASC)
-- CREATE NONCLUSTERED INDEX [i_handle_loc_pop_id] ON [Population] ([handle] ASC,[loc_pop_id] ASC)
-- ALTER TABLE [Population] ADD CONSTRAINT [pk_Population_pop_id]  PRIMARY KEY  CLUSTERED ([pop_id] ASC)
CREATE INDEX i_handle_loc_pop_id_upp ON Population (handle, loc_pop_id_upp);
CREATE INDEX i_handle_loc_pop_id ON Population (handle, loc_pop_id);
ALTER TABLE Population ADD PRIMARY KEY (pop_id);
CLUSTER Population USING population_pkey;

-- ALTER TABLE [AlleleFreqBySsPop] ADD CONSTRAINT [pk_AlleleFreqBySsPop_b129]  PRIMARY KEY  CLUSTERED ([subsnp_id] ASC,[pop_id] ASC,[allele_id] ASC)
ALTER TABLE AlleleFreqBySsPop ADD PRIMARY KEY (subsnp_id, pop_id, allele_id);
CLUSTER AlleleFreqBySsPop USING allelefreqbysspop_pkey;

-- CREATE CLUSTERED INDEX [i_ss] ON [SNPSubSNPLink] ([subsnp_id] ASC)
-- CREATE NONCLUSTERED INDEX [i_rs] ON [SNPSubSNPLink] ([snp_id] ASC,[subsnp_id] ASC,[substrand_reversed_flag] ASC)
-- ALTER TABLE [SNP] ADD CONSTRAINT [fk_exem_ss_2link] FOREIGN KEY (exemplar_subsnp_id) REFERENCES [SNPSubSNPLink](subsnp_id)
CREATE INDEX i_ss ON SNPSubSNPLink (subsnp_id);
CREATE INDEX i_rs ON SNPSubSNPLink (snp_id, subsnp_id, substrand_reversed_flag);
CLUSTER SNPSubSNPLink USING i_ss;

-- ALTER TABLE [SNPAlleleFreq] ADD CONSTRAINT [pk_SNPAlleleFreq]  PRIMARY KEY  CLUSTERED ([snp_id] ASC,[allele_id] ASC)
ALTER TABLE SNPAlleleFreq ADD PRIMARY KEY (snp_id, allele_id);
CLUSTER SNPAlleleFreq USING snpallelefreq_pkey;

-- ALTER TABLE [dn_PopulationIndGrp] ADD CONSTRAINT [pk_dn_PopulationIndGrp]  PRIMARY KEY  CLUSTERED ([pop_id] ASC)
ALTER TABLE dn_PopulationIndGrp ADD PRIMARY KEY (pop_id);
CLUSTER dn_PopulationIndGrp USING dn_populationindgrp_pkey;
