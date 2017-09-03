#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys


def main():
    source_id = sys.argv[1]

    for line in sys.stdin:
        record = ld2txt(line)
        if record:
            print '\t'.join([source_id] + record)

def ld2txt(line):
    """Parse plink.ld
    """
    # Replace PLINK's internal numeric coding of chromosomes: 23 -> X, 24 -> Y
    chrom = {'23': 'X', '24': 'Y'}

    record = line.strip().split()

    chr_a, bp_a, snp_a, chr_b, bp_b, snp_b, r2 = record

    # Skip records like SNP B == SNP A (itself)
    if snp_a == snp_b:
        return []

    # Skip records without rs ids ('.', 'esv~', etc.)
    if not snp_a.startswith('rs') or not snp_b.startswith('rs'):
        return []

    # Calc bp distance (from SNP A to SNP B)
    bp_dist = abs(int(bp_a) - int(bp_b))

    return [snp_a.replace('rs', ''), chrom.get(chr_a, chr_a), bp_a,
            snp_b.replace('rs', ''), chrom.get(chr_b, chr_b), bp_b,
            r2,
            str(bp_dist)]

if __name__ == '__main__':
    main()
