#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re

for line in sys.stdin:
    keys = []
    frqs = []

    for allele_freq in line.strip().split('\t'):
        try:
            k,f = re.findall(r'(^.+):(\d\.?\d*$)', allele_freq)[0]
        except Exception:
            print line
            raise Exception
        keys.append(k)
        frqs.append(f)

    print '\t'.join(['{' + ','.join(keys) + '}',
                     '{' + ','.join(frqs) + '}'])

    keys[:] = []
    frqs[:] = []
