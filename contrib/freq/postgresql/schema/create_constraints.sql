--
DROP INDEX IF EXISTS AlleleFreqIn1000GenomesPhase3_ukey_snp_id_allele;
CREATE UNIQUE INDEX AlleleFreqIn1000GenomesPhase3_ukey_snp_id_allele ON AlleleFreqIn1000GenomesPhase3_b37 (snp_id, allele) WHERE snp_id IS NOT NULL;

DROP INDEX IF EXISTS AlleleFreqIn1000GenomesPhase1_ukey_snp_id_allele;
CREATE UNIQUE INDEX AlleleFreqIn1000GenomesPhase1_ukey_snp_id_allele ON AlleleFreqIn1000GenomesPhase1_b37 (snp_id, allele);
