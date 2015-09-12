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
    return fasta.sequence({'chr': str(chrom), 'start': int(pos), 'stop': int(pos)}, one_based=True).upper()

def chromosomes(key, regexp):
    if regexp.search(key):
        return regexp.search(key).group(1)
    else:
        return key


def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('hapmap')
    parser.add_argument('--fa', required=True)
    args = parser.parse_args()

    fin = gzip.open(args.hapmap, 'rb') if os.path.splitext(args.hapmap)[1] == '.gz' else open(args.hapmap)
    chrom = re.findall(r'\.chr(.*)_', args.hapmap)[0]

    fa = Fasta(args.fa, key_fn=lambda key: chromosomes(key, re.compile('chr([0-9XY]+)')))

    reader = csv.DictReader(fin, delimiter=' ')
    sample_ids = sorted(list(set([x.strip('_A').strip('_B') for x in reader.fieldnames if x.endswith('_A') or x.endswith('_B')])))

    header_records = [('fileformat', 'VCFv4.1'),
                      ('reference', '.fa')] + \
                     [('contig', '<ID={},assembly=B36">'.format(c)) for c in range(1,23)] + \
                     [('FORMAT', '<ID=GT,Number=1,Type=String,Description="Genotype">')]
    writer = VCFWriter(sys.stdout, sample_ids, header_records)
    writer.writeheaderlines()

    for record in reader:
        row = {}
        row['#CHROM'] = chrom
        row['POS'] = record['position_b36']
        row['ID'] = record['rsID']

        ref = get_ref_allele(fa, chrom, record['position_b36'])
        alts = []

        for sample_id in sample_ids:
            alts.append(record[sample_id + '_A'])
            alts.append(record[sample_id + '_B'])

        assert ref in alts, (row, ref, set(alts))
        alts = list(set(alts) - set([ref]))
        alleles = [ref] + alts

        if not alts:
            alts = ['.']

        row['REF'] = ref
        row['ALT'] = alts
        row['QUAL'] = '.'
        row['FILTER'] = '.'
        row['INFO'] = []
        row['FORMAT'] = ['GT']

        for sample_id in sample_ids:
            row[sample_id] = [('GT', '{}|{}'.format(alleles.index(record[sample_id + '_A']), alleles.index(record[sample_id + '_B'])))]

        writer.writerow(row)


if __name__ == '__main__':
    _main()
