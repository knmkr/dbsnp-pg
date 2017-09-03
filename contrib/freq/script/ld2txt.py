#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

source_id = sys.argv[1]

# Replace PLINK's internal numeric coding of chromosomes: 23 -> X, 24 -> Y
chrom = {'23': 'X', '24': 'Y'}

for line in sys.stdin:
    record = line.strip().split()

    chr_a, bp_a, snp_a, chr_b, bp_b, snp_b, r2 = record

    # Skip records like SNP B == SNP A (itself)
    if snp_a == snp_b:
        continue

    # Skip records without rs ids ('.', 'esv~', etc.)
    if not snp_a.startswith('rs') or not snp_b.startswith('rs'):
        continue

    # Calc bp distance (from SNP A to SNP B)
    bp_dist = abs(int(bp_a) - int(bp_b))

    print '\t'.join([source_id,
                     snp_a.replace('rs', ''), chrom.get(chr_a, chr_a), bp_a,
                     snp_b.replace('rs', ''), chrom.get(chr_b, chr_b), bp_b,
                     r2,
                     str(bp_dist)])
