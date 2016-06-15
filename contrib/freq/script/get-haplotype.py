#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import shlex
import subprocess
from itertools import chain
from collections import Counter

import numpy as np
try:
    import psycopg2cffi as psycopg2
except ImportError:
    import psycopg2

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dbname', required=True)
    parser.add_argument('--dbuser', required=True)
    parser.add_argument('--source-id', required=True, choices=[4], type=int, help='Source ID. Currently, only 1000 Genomes Phase3 (CHB+JPT+CHS) is supported.')
    parser.add_argument('--rsids', required=True, nargs=2, type=int)
    parser.add_argument('--phased-allele-pair-only', action='store_true')
    parser.add_argument('--no-header', action='store_true')
    args = parser.parse_args()

    rsids = args.rsids

    # Get current chrom/pos
    conn = psycopg2.connect("dbname={} user={}".format(args.dbname, args.dbuser))
    cur = conn.cursor()
    cur.execute("SELECT chr, pos FROM get_pos_by_rs(ARRAY[%s, %s]);", (rsids[0], rsids[1],))
    rows = cur.fetchall()
    positions = rows

    sample = './sample_ids.1000genomes.phase3.CHB+JPT+CHS.txt'
    vcf = '../data/1000genomes.phase3/ALL.chr{chrom}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz'

    alleles = {}
    gt_matrix = None

    # Get phased genotypes
    for i, (chrom, pos) in enumerate(positions):
        cmd = shlex.split('bcftools view --no-header --regions "{chrpos}" --phased --samples-file {sample} {vcf}'.format(chrpos='{}:{}'.format(chrom, pos),
                                                                                                                         sample=sample,
                                                                                                                         vcf=vcf.format(chrom=chrom)))
        records = subprocess.check_output(cmd, stderr=subprocess.STDOUT).strip().split('\t')
        rsid, ref, alt = records[2:5]
        alleles[i] = [ref] + alt.split(',')
        genotypes = list(chain.from_iterable([[int(x) for x in gt.split('|')] for gt in records[9:]]))

        if gt_matrix is None:
            gt_matrix = np.array(genotypes)
        else:
            gt_matrix = np.vstack((gt_matrix, np.array(genotypes)))

    c = Counter([tuple(gt_matrix[:,i]) for i in xrange(gt_matrix.shape[1])])

    if args.phased_allele_pair_only:
        # Get phased allele pair
        phased_alleles = []
        for haplotype, count in c.most_common(2):
            for i, gt in enumerate(haplotype):
                phased_alleles.append(alleles[i][gt])

        # TODO: tri allele?

        if not args.no_header:
            print '\t'.join(['snp_a_id', 'phased_a1', 'phased_a2', 'snp_b_id', 'phased_b1', 'phased_b2'])
        print '\t'.join([str(rsids[0]), phased_alleles[0], phased_alleles[2], str(rsids[1]), phased_alleles[1], phased_alleles[3]])

    else:
        # Get haplotypes
        if not args.no_header:
            print '\t'.join(['observed_haplotype_count'] + [str(rsid) for rsid in rsids])

        for haplotype, count in c.most_common():
            phased_alleles = []
            for i, gt in enumerate(haplotype):
                phased_alleles.append(alleles[i][gt])

            print '\t'.join([str(count)] + phased_alleles)


if __name__ == '__main__':
    main()
