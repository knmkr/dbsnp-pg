#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import argparse
import gzip
import csv
import re

from pyfasta import Fasta
from vcf.writer import VCFWriter

def get_ref_allele(fasta, chrom, pos):
    return fasta.sequence({'chr': str(chrom), 'start': int(pos), 'stop': int(pos)}, one_based=True)

def chromosomes(key, regexp):
    if regexp.search(key):
        return regexp.search(key).group(1)
    else:
        return key


def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('hapmap')
    parser.add_argument('--fa', requreid=True)
    args = parser.parse_args()

    fin = gzip.open(args.hapmap, 'rb') if os.path.splitext(args.hapmap)[1] == '.gz' else open(args.hapmap)
    chrom = re.findall(r'\.chr(.*)_', args.hapmap)

    fa = Fasta(args.fa, key_fn=lambda key: chromosomes(key, re.compile('chr([0-9XY]+)')))

    reader = csv.DictReader(fin, delimiter=' ')
    sample_ids = set([x.strip('_A').strip('_B') for x in reader.fieldnames if x.endswith('_A') or x.endswith('_B')])

    # '#CHROM        POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  NA00001 NA00002 NA00003'

    for record in reader:
        row['#CHROM'] = chrom
        row['POS'] = record['position_b36']
        row['ID'] = record['rsID']

        ref = get_ref_allele(fa, chrom, record['position_b36'])
        alts = []

        for sample_id in sample_ids:
            alts.append(record[sample_id + '_A'])
            alts.append(record[sample_id + '_B'])
        alts = list(set(alts)).remove(ref)
        alleles = [ref] + alts

        row['REF'] = ref
        row['ALT'] = alts
        row['QUAL'] = '.'
        row['FILTER'] = '.'
        row['INFO'] = []
        row['FORMAT'] = ['GT']

        for sample_id in sample_ids:
            row[sample_id]['GT'] = '{}|{}'.format(alleles.index(record[sample_id + '_A']), alleles.index(record[sample_id + '_B']))

        print row
        break


    # reader = VCFReader(fin, filters=filters, decimal_prec=4)
    # writer = csv.DictWriter(sys.stdout, delimiter='\t', fieldnames=['snp_id', 'chrom', 'pos', 'allele', 'freq', 'source_id'])

    # for record in reader:
    #     for allele,freq in record['allele_freq'].items():
    #         if not record['rs']:
    #             continue

    #         if args.exclude_rsids and (record['rs'] in args.exclude_rsids):
    #             continue

    #         writer.writerow({'snp_id': record['rs'], 'chrom': record['CHROM'], 'pos': record['pos'], 'allele': allele, 'freq': freq, 'source_id': args.source_id})


if __name__ == '__main__':
    _main()
