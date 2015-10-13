#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import os
import sys
import csv
import decimal
import argparse
import datetime

def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('gwascatalog')
    args = parser.parse_args()

    date_downloaded = re.findall(r'gwas_catalog-downloaded_(\d{4}-\d{2}-\d{2}).tsv', os.path.basename(args.gwascatalog))[0]

    # ref: http://www.ebi.ac.uk/gwas/docs/fileheaders
    cols_map = [('DATE ADDED TO CATALOG',          'date_added',                     date),
                ('PUBMEDID',                       'pubmed_id',                      int),
                ('FIRST AUTHOR',                   'first_author',                   str),
                ('DATE',                           'date_published',                 date),
                ('JOURNAL',                        'journal',                        str),
                ('LINK',                           'pubmed_url',                     str),
                ('STUDY',                          'study_title',                    str),
                ('DISEASE/TRAIT',                  'disease_or_trait',               str),
                ('INITIAL SAMPLE DESCRIPTION',     'initial_sample',                 str),
                ('REPLICATION SAMPLE DESCRIPTION', 'replication_sample',             str),
                ('REGION',                         'region',                         str),
                ('CHR_ID',                         'chrom_reported',                 chrom),
                ('CHR_POS',                        'pos_reported',                   int),
                ('REPORTED GENE(S)',               'gene_reported',                  str),
                ('MAPPED_GENE',                    'gene_mapped',                    str),
                ('UPSTREAM_GENE_ID',               'upstream_entrez_gene_id',        str),  # when rs is not within gene
                ('DOWNSTREAM_GENE_ID',             'downstream_entrez_gene_id',      str),  # when rs is not within gene
                ('SNP_GENE_IDS',                   'entrez_gene_id',                 str),  # when rs is within gene
                ('UPSTREAM_GENE_DISTANCE',         'upstream_gene_distance_kb',      float),
                ('DOWNSTREAM_GENE_DISTANCE',       'downstream_gene_distance_kb',    float),
                ('STRONGEST SNP-RISK ALLELE',      'strongest_snp_risk_allele',      str),
                ('SNPS',                           'strongest_snps',                 str),
                ('MERGED',                         'is_snp_id_merged',               boolean),
                ('SNP_ID_CURRENT',                 'snp_id_current_reported',        str),
                ('CONTEXT',                        'snp_context',                    str),
                ('INTERGENIC',                     'is_snp_intergenic',              boolean),
                ('RISK ALLELE FREQUENCY',          'risk_allele_freq_reported',      float),
                ('P-VALUE',                        'p_value',                        probability),
                ('PVALUE_MLOG',                    'minus_log_p_value',              float),
                ('P-VALUE (TEXT)',                 'p_value_text',                   str),
                ('OR or BETA',                     'odds_ratio_or_beta_coeff',       float),
                ('95% CI (TEXT)',                  'confidence_interval_95_percent', str),
                ('PLATFORM [SNPS PASSING QC]',     'snp_platform',                   str),
                ('CNV',                            'cnv',                            str)]

    decimal.getcontext().prec = 1000

    cols_header = [x[1] for x in cols_map] + ['snp_id_reported', 'risk_allele', 'date_downloaded', 'snp_id_current']
    writer = csv.DictWriter(sys.stdout, fieldnames=cols_header, delimiter='\t')

    for record in csv.DictReader(open(args.gwascatalog), delimiter='\t'):
        row = {}
        for orig_name, col_name, col_type in cols_map:
            val = record[orig_name]

            if val == None:
                print >>sys.stderr, '[WARN] Invalid row? {}'.format(record)
                break

            val = val.strip()
            val = {'NR': '', 'NS': ''}.get(val, val)   # Null symbols

            if val != '':
                try:
                    val = col_type(val)
                except (ValueError, KeyError):
                    print >>sys.stderr, '[WARN] {}? {}: {}'.format(col_type, col_name, record[orig_name])
                    val = ''

            row[col_name] = val
        else:
            row['snp_id_reported'], row['risk_allele'] = split_to_snp_id_and_allele(row['strongest_snp_risk_allele'])
            row['date_downloaded'] = date_downloaded
            row['snp_id_current'] = row['snp_id_reported']  # In the later fllow, snp_id_current will be updated to current.
            writer.writerow(row)

def probability(x):
    p = decimal.Decimal(x)
    if 0 < p and p < 1:
        return x
    else:
        raise ValueError

def boolean(x):
    return {'0': 'f', '1': 't'}[x]

def date(x):
    '''
    >>> date('12/30/2008')
    '2008-12-30'
    >>> date('31-Mar-2009')
    '2009-03-31'
    >>> date('2015-09-12')
    '2015-09-12'
    >>> date('')
    ''
    '''

    d = ''
    for fmt in ['%m/%d/%Y', '%d-%b-%Y', '%Y-%m-%d']:
        try:
            d = datetime.datetime.strptime(x, fmt).strftime('%Y-%m-%d')
        except ValueError:
            pass
        else:
            break

    return d

def chrom(x):
    return {'23': 'X', '24': 'Y', '25': 'MT'}.get(x, x)

def split_to_snp_id_and_allele(x):
    '''
    >>> split_to_snp_id_and_allele('rs999943-T')
    ('999943', 'T')
    >>> split_to_snp_id_and_allele('rs999943-?')
    ('999943', '')
    >>> split_to_snp_id_and_allele('snp2-1167588-?')
    ('', '')
    >>> split_to_snp_id_and_allele('')
    ('', '')
    >>> split_to_snp_id_and_allele('rs9945428-? x rs4823535-?')  # TODO: support multiple snps
    ('', '')
    '''

    pattern = re.compile(r'^rs(\d+)-([ATGC]+|\?)\Z')
    match = pattern.findall(x)
    if match:
        snp_id, allele = match[0]
        allele = '' if allele == '?' else allele
    else:
        snp_id, allele = '', ''
    return snp_id, allele

if __name__ == '__main__':
    import doctest
    doctest.testmod()
    _main()
