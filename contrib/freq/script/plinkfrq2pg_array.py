#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import sys
from decimal import Decimal, InvalidOperation

def mustache(x):
    return '{' + ','.join(x) + '}'

for line in sys.stdin:
    # [.frq]
    # CHR     SNP   A1   A2          MAF  NCHROBS
    # 12   rs671    A    G      0.03591     4984
    #
    # [.frqx]
    # CHR	SNP	A1	A2	C(HOM A1)	C(HET)	C(HOM A2)	C(HAP A1)	C(HAP A2)	C(MISSING)
    # 12	rs671	A	G	20	139	2333	0	0	0

    if line.lstrip().startswith('CHR'):
        continue

    frq_rows, chrom_frqx, snp_frqx, a1_frqx, a2_frqx, n_a1_hom, n_het, n_a2_hom, n_a1_hap, n_a2_hap, n_missing = [x for x in line.rstrip().split('\t') if x != '']
    chrom, snp, a1, a2, a1_af, nchrobs = [x for x in frq_rows.split(' ') if x != '']

    try:
        assert chrom == chrom_frqx
        assert snp == snp_frqx
        assert a1 == a1_frqx
        assert a2 == a2_frqx
    except AssertionError as e:
        print >>sys.stderr, '[ERROR] Invalid .frq/.frqx line', line
        continue

    try:
        a2_af = '{}'.format(Decimal(1) - Decimal(a1_af))
    except InvalidOperation:
        print >>sys.stderr, '[ERROR] Invalid .frq/.frqx line', line
        continue

    # [.csv]
    # 671	{A,G}	{0.03591,0.96409}	{20,139,2333,0,0,0}
    print '\t'.join([snp,
                     mustache([a1, a2]),
                     mustache([a1_af, a2_af]),
                     mustache([n_a1_hom, n_het, n_a2_hom, n_a1_hap, n_a2_hap, n_missing])])
