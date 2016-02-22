#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import sys
from decimal import *

for line in sys.stdin:
    # Convert from .frq to .csv
    #
    # [.frq]
    #  CHR         SNP   A1   A2          MAF  NCHROBS
    #   12       rs671    A    G       0.2168      572
    #
    # [.csv]
    # {A,G}        {0.2168,0.7832}

    if line.lstrip().startswith('CHR'):
        continue

    chrom = line[0:4].strip()
    snp = line[4:16].strip()
    a1_minor = line[16:21].strip()
    a2_major = line[21:26].strip()
    a1_af = line[26:39].strip()
    a2_af = '{}'.format(Decimal(1) - Decimal(a1_af))
    nchrobs = line[39:48].strip()

    print '\t'.join([snp,
                     '{' + ','.join([a1_minor, a2_major]) + '}',
                     '{' + ','.join([a1_af,    a2_af])    + '}'])
