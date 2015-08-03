#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

PG_NULL = 'NULL'
PG_TRUE = 't'


if __name__ == '__main__':
    for line in sys.stdin:
        if line.startswith('#'):
            continue

        vcf_records = line.split('\t')

        chrom, pos, rsids, ref, alts = vcf_records[0:5]
        infos_raw = vcf_records[7]

        infos_splitted = (info.split('=') if len(info.split('=')) == 2 else [info, PG_TRUE] for info in infos_raw.rstrip(';').split(';'))
        infos = dict((k.strip(), v.strip()) for k,v in infos_splitted)

        for rsid_index,rsid in enumerate(rsids.split(';')):
            if rsid.startswith('rs'):
                rs = rsid.replace('rs', '')
            elif rsid == '.':
                rs = PG_NULL
            else:
                continue

            # CHROM	POS	ID	REF	ALT	INFO_EAS_AF	INFO_EUR_AF	INFO_AFR_AF	INFO_AMR_AF	INFO_SAS_AF
            print '\t'.join([chrom,
                             pos,
                             rs,
                             ref,
                             alts.split(',')[rsid_index],
                             infos['EAS_AF'].split(',')[rsid_index] if 'EAS_AF' in infos.keys() else PG_NULL,
                             infos['EUR_AF'].split(',')[rsid_index] if 'EUR_AF' in infos.keys() else PG_NULL,
                             infos['AFR_AF'].split(',')[rsid_index] if 'AFR_AF' in infos.keys() else PG_NULL,
                             infos['AMR_AF'].split(',')[rsid_index] if 'AMR_AF' in infos.keys() else PG_NULL,
                             infos['SAS_AF'].split(',')[rsid_index] if 'SAS_AF' in infos.keys() else PG_NULL])
