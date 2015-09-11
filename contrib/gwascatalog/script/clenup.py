#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys
import csv
import argparse


def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('gwascatalog')
    args = parser.parse_args()

    # ref: http://www.ebi.ac.uk/gwas/docs/fileheaders
    cols_map = [('Date Added to Catalog',          'date_added_to_catalog',          date),
                ('PUBMEDID',                       'pubmed_id',                      int),
                ('First Author',                   'first_author',                   str),
                ('Date',                           'date_published',                 date),
                ('Journal',                        'journal',                        str),
                ('Link',                           'pubmed_url',                     str),
                ('Study',                          'study_title',                    str),
                ('Disease/Trait',                  'disease_or_trait',               str),
                ('Initial Sample Description',     'initial_sample',                 str),
                ('Replication Sample Description', 'replication_sample',             str),
                ('Region',                         'region',                         str),
                ('Chr_id',                         'chr',                            chrom),
                ('Chr_pos',                        'pos',                            int),
                ('Reported Gene(s)',               'gene_reported',                  str),
                ('Mapped_gene',                    'gene_mapped',                    str),
                ('Upstream_gene_id',               'upstream_entrez_gene_id',        str),  # when rs is not within gene
                ('Downstream_gene_id',             'downstream_entrez_gene_id',      str),  # when rs is not within gene
                ('Snp_gene_ids',                   'entrez_gene_id',                 str),  # when rs is within gene
                ('Upstream_gene_distance',         'upstream_gene_distance_kb',      float),
                ('Downstream_gene_distance',       'downstream_gene_distance_kb',    float),
                ('Strongest SNP-Risk Allele',      'strongest_snp_risk_allele',      str),
                ('SNPs',                           'strongest_snps',                 str),
                ('Merged',                         'is_snp_id_merged',               boolean),
                ('Snp_id_current',                 'snp_id_current',                 str),
                ('Context',                        'snp_context',                    str),
                ('Intergenic',                     'is_snpintergenic',               boolean),
                ('Risk Allele Frequency',          'risk_allele_freq_reported',      float),
                ('p-Value',                        'p_value',                        float),
                ('Pvalue_mlog',                    'minus_log_p_value_',             float),
                ('p-Value (text)',                 'p_value_text',                   str),
                ('OR or beta',                     'odds_ratio_or_beta_coeff',       float),
                ('95% CI (text)',                  'confidenceinterval_95_percent',  str),
                ('Platform [SNPs passing QC]',     'snp_platform',                   str),
                ('CNV',                            'cnv',                            str)]

    cols_header = [x[1] for x in cols_map] + ['snp_id', 'risk_allele']
    writer = csv.DictWriter(sys.stdout, fieldnames=cols_header, delimiter='\t')
    writer.writeheader()

    for record in csv.DictReader(open(args.gwascatalog), delimiter='\t'):
        row = {}
        for orig_name, col_name, col_type in cols_map:
            val = record[orig_name]

            if val == None:
                print >>sys.stderr, '[WARN] Invalid row? {}'.format(record)
                break

            val = val.strip()
            val = {'NR': '', 'NS': ''}.get(val, val)

            if val != '':
                try:
                    val = col_type(val)
                except (ValueError, KeyError):
                    print >>sys.stderr, '[WARN] {}? {}: {}'.format(col_type, col_name, record[orig_name])
                    val = ''

            row[col_name] = val
        else:
            row['snp_id'], row['risk_allele'] = split_to_snp_id_and_allele(row['strongest_snp_risk_allele'])
            writer.writerow(row)

def boolean(x):
    return {'0': 'f', '1': 't'}[x]

def date(x):
    '''
    >>> date('12/30/2008')
    '2018-12-30'
    >>> date('31-Mar-2009')
    '2009-03-31'
    '''
    # TODO: not implemented
    return str(x)

def chrom(x):
    return {'23': 'X', '24': 'Y', '25': 'MT'}.get(x, x)

def split_to_snp_id_and_allele(x):
    '''
    >>> split_to_snp_id_and_allele('rs999943-T')
    (999943, 'T')
    >>> split_to_snp_id_and_allele('snp2-1167588-?')
    ('', '')
    >>> split_to_snp_id_and_allele('rs9945428-? x rs4823535-?')  # TODO: support multiple snps
    ('', '')
    '''
    # TODO: not implemented
    return x,x


if __name__ == '__main__':
    _main()
