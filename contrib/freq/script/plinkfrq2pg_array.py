#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import sys
from decimal import *

for line in sys.stdin:
    # Convert from .frq to .csv
    #
    # [.frq]
    #  CHR          SNP   A1   A2          MAF  NCHROBS
    #    1  rs140337953    G    T       0.1101      572
    #    1  rs199681827 CTGT    C     0.001748      572
    #
    # [.csv]
    # 140337953  {G,T}     {0.1101,0.8899}
    # 199681827  {CTGT,C}  {0.001748,0.998252}

    if line.lstrip().startswith('CHR'):
        continue

    chrom, snp, a1_minor, a2_major, a1_af, nchrobs = [x for x in line.split(' ') if x != '']
    a2_af = '{}'.format(Decimal(1) - Decimal(a1_af))

    print '\t'.join([snp,
                     '{' + ','.join([a1_minor, a2_major]) + '}',
                     '{' + ','.join([a1_af,    a2_af])    + '}'])
