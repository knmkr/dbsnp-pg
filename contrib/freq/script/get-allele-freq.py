#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import argparse
import gzip
import csv

from vcf.reader import VCFReader
from vcf.filters import sample_names_in


def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('vcf')
    parser.add_argument('--sample-ids')
    args = parser.parse_args()

    filters = {}
    if args.sample_ids:
        sample_ids = [line.strip() for line in open(args.sample_ids)]
        filters.update({'genotype': sample_names_in(sample_ids)})

    reader = VCFReader(gzip.open(args.vcf, 'rb'), filters=filters)
    writer = csv.DictWriter(sys.stdout, delimiter='\t', fieldnames=['snp_id', 'chrom', 'pos', 'allele', 'freq'])

    for record in reader:
        for allele,freq in record['allele_freq'].items():
            writer.writerow({'snp_id': record['rs'], 'chrom': record['CHROM'], 'pos': record['pos'], 'allele': allele, 'freq': freq})


if __name__ == '__main__':
    _main()
