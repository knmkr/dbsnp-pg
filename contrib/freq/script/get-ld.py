#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import sys
import os
import shlex
import subprocess
from ld2txt import ld2txt
BASE_DIR = os.path.dirname(os.path.realpath(__file__))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--source-id', required=True, choices=[3,4, 100, 200, 300], type=int)
    parser.add_argument('--rsids', nargs='+', type=int)
    parser.add_argument('--rsids-file', type=file)
    parser.add_argument('--dbname')
    parser.add_argument('--dbuser')
    parser.add_argument('--dbhost')
    parser.add_argument('--min-r2', default=0.8, type=float)
    args = parser.parse_args()

    rsids = args.rsids
    query = '.q.txt'

    context = {
        'script': os.path.join(BASE_DIR, 'get-vcf.py'),
        'source_id': args.source_id,
        'rsids': ' '.join([str(x) for x in rsids]),
        'dbname': args.dbname,
        'dbuser': args.dbuser,
        'dbhost': args.dbhost,
    }
    with open(query, 'w') as fout:
        cmd = shlex.split('{script} --source-id {source_id} --rsids {rsids} --dbname {dbname} --dbuser {dbuser} --dbhost {dbhost}'.format(**context))
        results = subprocess.call(cmd, stdout=fout)

    subprocess.call(shlex.split('plink --vcf {query} --make-bed --out {query}'.format(query=query)), stdout=sys.stderr, stderr=sys.stderr)

    print '\t'.join(['snp_a', 'chrom_a', 'pos_a', 'snp_b', 'chrom_b', 'pos_b', 'r2', 'bp_dist'])

    for snp in args.rsids:
        subprocess.call(shlex.split('plink --bfile {query} --r2 --ld-snp rs{snp} --ld-window-r2 {min_r2}'.format(query=query, snp=snp, min_r2=args.min_r2)), stdout=sys.stderr, stderr=sys.stderr)

        with open('plink.ld', 'r') as fin:
            for line in fin:
                record = ld2txt(line)
                if record:
                    print '\t'.join(record)

if __name__ == '__main__':
    main()
