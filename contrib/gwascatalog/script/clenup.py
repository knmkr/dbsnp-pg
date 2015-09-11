#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import csv
import argparse


def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('gwascatalog')
    args = parser.parse_args()

    # ref: http://www.ebi.ac.uk/gwas/docs/fileheaders
    cols_map = [['Date Added to Catalog',          'date_added_to_catalog',          _date],
                ['PUBMEDID',                       'pubmed_id',                      _int],
                ['First Author',                   'first_author',                   _str],
                ['Date',                           'date_published',                 _date],
                ['Journal',                        'journal',                        _str],
                ['Link',                           'pubmed_url',                     _str],
                ['Study',                          'study_title',                    _str],
                ['Disease/Trait',                  'disease_or_trait',               _str],
                ['Initial Sample Description',     'initial_sample',                 _str],
                ['Replication Sample Description', 'replication_sample',             _str],
                ['Region',                         'region',                         _str],
                ['Chr_id',                         'chr',                            _str],
                ['Chr_pos',                        'pos',                            _int],
                ['Reported Gene(s)',               'gene_reported',                  _str],
                ['Mapped_gene',                    'gene_mapped',                    _str],
                ['Upstream_gene_id',               'upstream_entrez_gene_id',        _str],  # when rs is not within gene
                ['Downstream_gene_id',             'downstream_entrez_gene_id',      _str],  # when rs is not within gene
                ['Snp_gene_ids',                   'entrez_gene_id',                 _str],  # when rs is within gene
                ['Upstream_gene_distance',         'upstream_gene_distance_kb',      _int],
                ['Downstream_gene_distance',       'downstream_gene_distance_kb',    _int],
                ['Strongest SNP-Risk Allele',      'strongest_snp_risk_allele',      _str],
                ['SNPs',                           'strongest_snps',                 _str],
                ['Merged',                         'is_snp_id_merged',               _bool],  # 0 = no; 1 = yes
                ['Snp_id_current',                 'snp_id_current',                 _str],
                ['Context',                        'snp_context',                    _str],
                ['Intergenic',                     'is_snp_intergenic',              _bool],  # 0 = no; 1 = yes
                ['Risk Allele Frequency',          'risk_allele_freq_reported',      _float],
                ['p-Value',                        'p_value',                        _float],
                ['Pvalue_mlog',                    'minus_log_p_value_',             _float],
                ['p-Value (text)',                 'p_value_text',                   _str],
                ['OR or beta',                     'odds_ratio_or_beta_coeff',       _str],
                ['95% CI (text)',                  'confidence_interval_95_percent', _str],
                ['Platform [SNPs passing QC]',     'snp_platform',                   _str],
                ['CNV',                            'cnv',                            _str]]

    cols_header = [x[1] for x in cols_map]
    writer = csv.DictWriter(sys.stdout, fieldnames=cols_header, delimiter='\t')
    writer.writeheader()

    for record in csv.DictReader(open(args.gwascatalog), delimiter='\t'):
        row = {}
        for orig_name, col_name, col_type in cols_map:
            row[col_name] = col_type(record[orig_name])
        writer.writerow(row)

def _str(x):
    return str(x)

def _int(x):
    try:
        return int(x)
    except ValueError:
        return ''

def _float(x):
    try:
        return float(x)
    except ValueError:
        return ''

def _bool(x):
    return {0: 'f', 1: 't'}.get(x, '')

def _date(x):
    return str(x)

if __name__ == '__main__':
    _main()
