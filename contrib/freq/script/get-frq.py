#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import csv
from decimal import *

try:
    import psycopg2cffi as psycopg2
except ImportError:
    import psycopg2

def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dbname', required=True)
    parser.add_argument('--dbuser', required=True)
    parser.add_argument('--source-id', required=True)
    parser.add_argument('--rsids', required=True, nargs='+', type=int)
    args = parser.parse_args()

    print ' CHR         SNP   A1   A2          MAF  NCHROBS'

    conn = psycopg2.connect("dbname={} user={}".format(args.dbname, args.dbuser))
    cur = conn.cursor()
    cur.execute("SELECT * FROM get_tbl_allele_freq_by_rs_history(%s, %s);", (args.source_id, args.rsids,))
    rows = cur.fetchall()

    records = {}

    for row in rows:
        snp_id, snp_current, allele, freq = row

        if not (allele and freq):
            raw_chr     = '{0: >4}'.format('.')
            raw_snp     = '{0: >12}'.format('rs' + str(snp_id))
            raw_a1      = '{0: >5}'.format('.')
            raw_a2      = '{0: >5}'.format('.')
            raw_maf     = '{0: >13}'.format('.')
            raw_nchrobs = '{0: >9}'.format('.')
        else:
            allele_freq = dict(zip(allele, freq))
            assert len(allele) == 2, row
            minor = freq.index(sorted(freq)[0])
            major = freq.index(sorted(freq)[-1])

            raw_chr     = '{0: >4}'.format('.')
            raw_snp     = '{0: >12}'.format('rs' + str(snp_id))
            raw_a1      = '{0: >5}'.format(allele[minor])
            raw_a2      = '{0: >5}'.format(allele[major])
            raw_maf     = '{0: >13.4f}'.format(Decimal(allele_freq[allele[minor]]))
            raw_nchrobs = '{0: >9}'.format('.')

        record = raw_chr + raw_snp + raw_a1 + raw_a2 + raw_maf + raw_nchrobs
        records[snp_id] = record

    for rsid in args.rsids:
        print records[rsid]


if __name__ == '__main__':
    _main()
