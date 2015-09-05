DROP INDEX IF EXISTS allelefreq_1_ukey_snp_id_allele;
CREATE UNIQUE INDEX allelefreq_1_ukey_snp_id_allele ON AlleleFreq_1 (snp_id, allele);

DROP INDEX IF EXISTS allelefreq_2_ukey_snp_id_allele;
CREATE UNIQUE INDEX allelefreq_2_ukey_snp_id_allele ON AlleleFreq_2 (snp_id, allele);
