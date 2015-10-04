#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import csv
import gzip
import argparse

from vcf.reader import VCFReader
from vcf.filters import *


def pg_array(l):
    return '{' + ','.join([str(x) for x in l]) + '}'

def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('vcf')
    parser.add_argument('--sample-ids', required=True)
    args = parser.parse_args()

    sample_ids = [l.strip() for l in open(args.sample_ids)]
    filters = {'genotype': sample_names_in(sample_ids)}

    fin = gzip.open(args.vcf, 'rb') if os.path.splitext(args.vcf)[1] == '.gz' else open(args.vcf)
    reader = VCFReader(fin, filters=filters, decimal_prec=4)

    for record in reader:
        if not record['rs']:
            continue

        allele = record['allele_freq'].keys()
        freq = record['allele_freq'].values()
        print '\t'.join([str(record['rs']), pg_array(allele), pg_array(freq)])

if __name__ == '__main__':
    _main()
