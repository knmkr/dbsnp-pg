#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

PG_NULL = 'NULL'
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

def get_freq_from_info(infos, code, rsid_index):
    """
    >>> get_freq_from_info({'EAS_AF': '0.1,0.2,0.3'}, 'EAS_AF', [0,2])
    ['0.1', '0.3']
    >>> get_freq_from_info({}, 'EAS_AF', [0,2])
    ['NULL', 'NULL']
    """
    if code in infos:
        return value_by_index(infos[code].split(','), rsid_index)
    else:
        return [PG_NULL] * len(rsid_index)

def format_row(record):
    # CHROM	POS	ID	REF	ALT	INFO_EAS_AF	INFO_EUR_AF	INFO_AFR_AF	INFO_AMR_AF	INFO_SAS_AF
    return '\t'.join([record['chrom'],
                      record['pos'],
                      record['rs'],
                      mustache(record['ref']),
                      mustache(record['alt']),
                      mustache(record['freq']['EAS_AF']),
                      mustache(record['freq']['EUR_AF']),
                      mustache(record['freq']['AFR_AF']),
                      mustache(record['freq']['AMR_AF']),
                      mustache(record['freq']['SAS_AF'])])

def _main():
    prev = []
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

            refs = ref.split(',')
            assert len(refs) == 1
            alts = value_by_index(alt.split(','), rsid_index)
            freq = {'EAS_AF': get_freq_from_info(infos, 'EAS_AF', rsid_index),
                    'EUR_AF': get_freq_from_info(infos, 'EUR_AF', rsid_index),
                    'AFR_AF': get_freq_from_info(infos, 'AFR_AF', rsid_index),
                    'AMR_AF': get_freq_from_info(infos, 'AMR_AF', rsid_index),
                    'SAS_AF': get_freq_from_info(infos, 'SAS_AF', rsid_index)}

            # Store current record
            record = {'chrom': chrom,  'pos': pos, 'rs': rs, 'ref': refs*len(alts), 'alt': alts, 'freq': freq}

            if not prev:
                prev = record
            else:
                # Columns (chrom,pos,rsid) should be uniq in table
                if (record['chrom'], record['pos'], record['rs']) != (prev['chrom'], prev['pos'], prev['rs']):
                    print format_row(prev)
                    prev = record
                else:
                    prev['ref'] += record['ref']
                    prev['alt'] += record['alt']
                    prev['freq']['EAS_AF'] += record['freq']['EAS_AF']
                    prev['freq']['EUR_AF'] += record['freq']['EUR_AF']
                    prev['freq']['AFR_AF'] += record['freq']['AFR_AF']
                    prev['freq']['AMR_AF'] += record['freq']['AMR_AF']
                    prev['freq']['SAS_AF'] += record['freq']['SAS_AF']

    # Output last prev
    print format_row(prev)


if __name__ == '__main__':
    import doctest
    doctest.testmod()
    _main()
