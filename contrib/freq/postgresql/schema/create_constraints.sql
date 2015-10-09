-- Constraints on "child" table
-- DROP INDEX IF EXISTS allelefreq_1_snp_id_allele;
DROP INDEX IF EXISTS allelefreq_2_snp_id_allele;
-- DROP INDEX IF EXISTS allelefreq_3_snp_id_allele;
-- DROP INDEX IF EXISTS allelefreq_4_snp_id_allele;
-- DROP INDEX IF EXISTS allelefreq_5_snp_id_allele;
-- DROP INDEX IF EXISTS allelefreq_6_snp_id_allele;
-- DROP INDEX IF EXISTS allelefreq_100_snp_id_allele;
-- DROP INDEX IF EXISTS allelefreq_200_snp_id_allele;
-- CREATE INDEX allelefreq_1_snp_id_allele ON AlleleFreq_1 (snp_id, allele);
CREATE INDEX allelefreq_2_snp_id_allele ON AlleleFreq_2 (snp_id);
-- CREATE INDEX allelefreq_3_snp_id_allele ON AlleleFreq_3 (snp_id, allele);
-- CREATE INDEX allelefreq_4_snp_id_allele ON AlleleFreq_4 (snp_id, allele);
-- CREATE INDEX allelefreq_5_snp_id_allele ON AlleleFreq_5 (snp_id, allele);
-- CREATE INDEX allelefreq_6_snp_id_allele ON AlleleFreq_6 (snp_id, allele);
-- CREATE INDEX allelefreq_100_snp_id_allele ON AlleleFreq_100 (snp_id, allele);
-- CREATE INDEX allelefreq_200_snp_id_allele ON AlleleFreq_200 (snp_id, allele);
