#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import re
import argparse
import glob
import shlex
import subprocess

try:
    import psycopg2cffi as psycopg2
except ImportError:
    import psycopg2

from filter import get_rsid

BASE_DIR = os.path.dirname(os.path.realpath(__file__))

# TODO: Load from settings.py if exists.
DBNAME = 'dbsnp_b146_GRCh37'
DBUSER = 'dbsnp'

RSID_PATTERN = re.compile('rs(\d+)')

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--source-id', required=True, choices=[3,4, 100, 200, 300], type=int)
    parser.add_argument('--rsids', nargs='+', type=int)
    parser.add_argument('--dbname', default=DBNAME)
    parser.add_argument('--dbuser', default=DBUSER)
    parser.add_argument('--regions', nargs='+', type=str)
    args = parser.parse_args()

    rsids = args.rsids

    if args.regions:
        positions = [tuple(x.split(':')) for x in args.regions]
    else:
        if not args.dbname or not args.dbuser:
            print >>sys.stderr, '[ERROR] If --regions is not set, you need to set --dbname and --dbuser (error code AR1).'
            sys.exit(1)

        # Get current chrom/pos
        conn = psycopg2.connect("dbname={} user={}".format(args.dbname, args.dbuser))
        cur = conn.cursor()
        cur.execute("SELECT chr, pos FROM get_pos_by_rs(ARRAY[%s]);", (rsids,))
        rows = cur.fetchall()
        positions = rows

    sample = {
        3:   os.path.join(BASE_DIR, 'sample_ids.1000genomes.phase1.CHB+JPT+CHS.txt'),
        4:   os.path.join(BASE_DIR, 'sample_ids.1000genomes.phase3.CHB+JPT+CHS.txt'),
        100: os.path.join(BASE_DIR, 'sample_ids.1000genomes.phase3.CEU.no-pat-mat.txt'),
        200: os.path.join(BASE_DIR, 'sample_ids.1000genomes.phase3.YRI.no-pat-mat.txt'),
        300: os.path.join(BASE_DIR, 'sample_ids.1000genomes.phase3.no-pat-mat.txt'),
    }[args.source_id]

    vcf = {
        3:   os.path.join(BASE_DIR, '..', 'data/1000genomes.phase1/ALL.chr{chrom}.*.vcf.gz'),
        4:   os.path.join(BASE_DIR, '..', 'data/1000genomes.phase3/ALL.chr{chrom}.*.vcf.gz'),
        100: os.path.join(BASE_DIR, '..', 'data/1000genomes.phase3/ALL.chr{chrom}.*.vcf.gz'),
        200: os.path.join(BASE_DIR, '..', 'data/1000genomes.phase3/ALL.chr{chrom}.*.vcf.gz'),
        300: os.path.join(BASE_DIR, '..', 'data/1000genomes.phase3/ALL.chr{chrom}.*.vcf.gz'),
    }[args.source_id]

    for i, (chrom, pos) in enumerate(positions):
        vcf_in = glob.glob(vcf.format(chrom=chrom))

        if not vcf_in:
            log(rsids[i], 'vcf record not found (error code NA4). chrom:{}, position:{}'.format(chrom, pos))
            sys.exit(0)

        # Print VCF header lines
        if i == 0:
            cmd = shlex.split('bcftools view --header-only --samples-file {sample} {vcf}'.format(chrpos='{}:{}'.format(chrom, pos),
                                                                                                 sample=sample,
                                                                                                 vcf=vcf_in[0]))
            results = subprocess.check_output(cmd, stderr=subprocess.STDOUT).splitlines()

            for line in results:
                if line.startswith('#'):
                    print line

        # bcftools view         View, subset and filter VCF or BCF files by position and filtering expression. Convert between VCF and BCF. Former bcftools subset.
        #
        # --no-header           suppress the header in VCF output
        # --regions             Comma-separated list of regions, see also -R, --regions-file. Note that -r cannot be used in combination with -R.
        # --samples-file        File of sample names to include or exclude if prefixed with "^". One sample per line.
        cmd = shlex.split('bcftools view --no-header --regions "{chrpos}" --samples-file {sample} {vcf}'.format(chrpos='{}:{}'.format(chrom, pos),
                                                                                                                sample=sample,
                                                                                                                vcf=vcf_in[0]))
        try:
            results = subprocess.check_output(cmd, stderr=subprocess.STDOUT).splitlines()
        except Exception as e:
            log(rsids[i], 'vcf record not found (error code NA3). chrom:{}, position:{}'.format(chrom, pos))
            sys.exit(0)

        founds = []
        for result in results:
            records = result.split('\t')

            # FIXME: need to handle multiple hits
            if records[0] == chrom and int(records[1]) == int(pos):
                founds.append(result)

        if not founds:
            log(rsids[i], 'vcf record not found (error code NA1). chrom:{}, position:{}'.format(chrom, pos))
            sys.exit(0)

        for found in founds:
            # Replace to rs ids in query
            rec = found.split('\t')
            print '\t'.join(rec[0:2] + ['rs' + str(rsids[i])] + rec[3:])


def log(rsid, msg):
    print >>sys.stderr, '{}\t{}'.format(rsid, msg)


if __name__ == '__main__':
    main()
