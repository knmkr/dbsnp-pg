#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import argparse
import gzip
import csv

from vcf.reader import VCFReader
from vcf.filters import *


def list2pg_array(l):
    return '{' + ','.join([str(x) for x in l]) + '}'

def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('vcf')
    parser.add_argument('--source-id', required=True)
    parser.add_argument('--sample-ids', required=True)
    parser.add_argument('--include-rsids')
    args = parser.parse_args()

    sample_ids = [line.strip() for line in open(args.sample_ids)]
    filters = {'genotype': sample_names_in(sample_ids)}

    if args.include_rsids:
        rsids = [int(line.strip()) for line in open(args.include_rsids)]
        filters.update({'rs': rsid_in(rsids)})

    fin = gzip.open(args.vcf, 'rb') if os.path.splitext(args.vcf)[1] == '.gz' else open(args.vcf)
    reader = VCFReader(fin, filters=filters, decimal_prec=4)
    writer = csv.DictWriter(sys.stdout, delimiter='\t', fieldnames=['snp_id', 'allele', 'freq', 'source_id'])

    for record in reader:
        if not record['rs']:
            continue

        af = record['allele_freq']
        allele = list2pg_array(af.keys())
        freq = list2pg_array(af.values())

        writer.writerow({'snp_id': record['rs'], 'allele': allele, 'freq': freq, 'source_id': args.source_id})


if __name__ == '__main__':
    _main()
