-- AlleleFreqIn1000GenomesPhase3_b37
CREATE INDEX AlleleFreqIn1000GenomesPhase3_chr_pos ON AlleleFreqIn1000GenomesPhase3_b37 (chr, pos);
CREATE INDEX AlleleFreqIn1000GenomesPhase3_snp_id ON AlleleFreqIn1000GenomesPhase3_b37 (snp_id);
CREATE UNIQUE INDEX AlleleFreqIn1000GenomesPhase3_ukey_snp_id_chr_pos ON AlleleFreqIn1000GenomesPhase3_b37 (snp_id, chr, pos);
