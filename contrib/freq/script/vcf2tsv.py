#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

pg_null = ''
pg_true = 't'

def mustache(s):
    return '{' + s + '}'

for line in sys.stdin:
    if line.startswith('#'):
        continue

    vcf_records = line.split('\t')

    chrom, pos, rsids, ref, alt = vcf_records[0:5]
    infos_raw = vcf_records[7]

    infos_splitted = (info.split('=') if len(info.split('=')) == 2 else [info, pg_true] for info in infos_raw.rstrip(';').split(';'))
    infos = dict((k.strip(), v.strip()) for k,v in infos_splitted)

    for i,rsid in enumerate(rsids.split(';')):
        if rsid.startswith('rs'):
            rs = rsid.replace('rs', '')
        elif rsid == '.':
            rs = pg_null
        else:
            continue

        # CHROM    POS    ID    REF    ALT    INFO_EAS_AF    INFO_EUR_AF    INFO_AFR_AF    INFO_AMR_AF    INFO_SAS_AF
        print '\t'.join([chrom,
                         pos,
                         rs,
                         ref,
                         mustache(alt.split(',')[i]),
                         mustache(infos.get('EAS_AF', pg_null).split(',')[i]),
                         mustache(infos.get('EUR_AF', pg_null).split(',')[i]),
                         mustache(infos.get('AFR_AF', pg_null).split(',')[i]),
                         mustache(infos.get('AMR_AF', pg_null).split(',')[i]),
                         mustache(infos.get('SAS_AF', pg_null).split(',')[i])])
