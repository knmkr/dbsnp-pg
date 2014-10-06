#!/usr/bin/env python
# -*- coding: utf-8 -*-

import fileinput
import csv

def _main():
    rs = None
    rs2freq = {}
    ref_allele = None

    print '\t'.join(['CHR', 'SNP', 'A1', 'A2', 'MAF', 'NCHROBS'])

    for rec in csv.DictReader(fileinput.input(), delimiter='\t'):
        if not rs:
            # init freq record
            rs = rec['rshigh']
            rs2freq[rs] = {rec['allele']: rec['freq']}
            ref_allele = rec['ref_allele']

        elif rs == rec['rshigh']:
            # udpate freq record
            rs2freq[rs].update({rec['allele']: rec['freq']})
            assert ref_allele == rec['ref_allele']

        elif rs != rec['rshigh']:
            # output freq record in .frq format
            allele_count = len(rs2freq[rs])

            if allele_count == 2:
                _A1, _A2 = sorted(rs2freq[rs].items(), key=lambda x:x[1])
                A1 = _A1[0]
                A2 = _A2[0]
                MAF = _A1[1]

            elif allele_count == 1:
                _A1 = rs2freq[rs].items()[0]
                A1 = _A1[0]
                A2 = ref_allele
                MAF = _A1[1]
                if A1 == A2:
                    A2 = '?'

            else:
                A1 = ''
                A2 = ''
                MAF = ''

            # TODO:
            CHR = '?'
            SNP = rs if rs.startswith('rs') else 'rs{}'.format(rs)
            NCHROBS = '?'

            print '\t'.join([CHR, SNP, A1, A2, MAF, NCHROBS])

            rs = None
            rs2freq = {}


if __name__ == '__main__':
    _main()
