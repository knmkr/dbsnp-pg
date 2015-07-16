#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

PG_NULL = ''
PG_TRUE = 't'

def mustache(record):
    """
    >>> mustache('abc')
    '{abc}'
    >>> mustache(['a', 'b', 'c'])
    '{a,b,c}'
    """

    if type(record) == str:
        return '{' + record + '}'
    elif type(record) == list:
        return '{' + ','.join(record) + '}'

def value_by_index(values, indices):
    """
    >>> value_by_index(['a', 'b', 'c'], [0, 2])
    ['a', 'c']
    """

    return [value for i,value in enumerate(values) if i in indices]

def _main():
    for line in sys.stdin:
        if line.startswith('#'):
            continue

        vcf_records = line.split('\t')

        chrom, pos, rsids, ref, alt = vcf_records[0:5]
        infos_raw = vcf_records[7]

        infos_splitted = (info.split('=') if len(info.split('=')) == 2 else [info, PG_TRUE] for info in infos_raw.rstrip(';').split(';'))
        infos = dict((k.strip(), v.strip()) for k,v in infos_splitted)

        rsids = rsids.split(';')
        rsid_indices = dict()
        for uniq_rsid in set(rsids):
            rsid_indices[uniq_rsid] = [i for i,rsid in enumerate(rsids) if rsid == uniq_rsid]

        for rsid, rsid_index in rsid_indices.items():
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
                             mustache(value_by_index(alt.split(','), rsid_index)),
                             mustache(value_by_index(infos.get('EAS_AF', PG_NULL).split(','), rsid_index)),
                             mustache(value_by_index(infos.get('EUR_AF', PG_NULL).split(','), rsid_index)),
                             mustache(value_by_index(infos.get('AFR_AF', PG_NULL).split(','), rsid_index)),
                             mustache(value_by_index(infos.get('AMR_AF', PG_NULL).split(','), rsid_index)),
                             mustache(value_by_index(infos.get('SAS_AF', PG_NULL).split(','), rsid_index))])

if __name__ == '__main__':
    import doctest
    doctest.testmod()
    _main()
