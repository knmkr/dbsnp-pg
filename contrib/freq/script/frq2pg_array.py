#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re

for line in sys.stdin:
    keys = []
    frqs = []

    # Convert from .frq to .csv
    #
    # [.frq]
    # G:0.982099   A:0.0179007
    # G:-nan       A:-nan
    #
    # [.csv]
    # {G,A}        {0.982099,0.0179007}
    # {}           {}
    for allele_freq in line.strip().split('\t'):
        founds = re.findall(r'(.+):(\d\.?\d*|-nan)', allele_freq)

        if not founds:
            print >>sys.stderr, '[WARN]', line,
            continue

        k, f = founds[0]

        if f == '-nan':
            print >>sys.stderr, '[WARN]', line,
            continue

        keys.append(k)
        frqs.append(f)

    print '\t'.join(['{' + ','.join(keys) + '}',
                     '{' + ','.join(frqs) + '}'])

    keys[:] = []
    frqs[:] = []
