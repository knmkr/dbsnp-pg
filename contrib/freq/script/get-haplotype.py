#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import glob
import shlex
import subprocess
from itertools import chain
from collections import Counter

import numpy as np
try:
    import psycopg2cffi as psycopg2
except ImportError:
    import psycopg2

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dbname', required=True)
    parser.add_argument('--dbuser', required=True)
    parser.add_argument('--rsids', required=True, nargs=2, type=int)
    parser.add_argument('--source-id', required=True, choices=[3,4], type=int)
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

    sample = {
        3: os.path.join(BASE_DIR, 'sample_ids.1000genomes.phase1.CHB+JPT+CHS.txt'),
        4: os.path.join(BASE_DIR, 'sample_ids.1000genomes.phase3.CHB+JPT+CHS.txt'),
    }[args.source_id]

    vcf = {
        3: os.path.join(BASE_DIR, '..', 'data/1000genomes.phase1/ALL.chr{chrom}.*.vcf.gz'),
        4: os.path.join(BASE_DIR, '..', 'data/1000genomes.phase3/ALL.chr{chrom}.*.vcf.gz'),
    }[args.source_id]

    alleles = {}
    gt_matrix = None

    # Get phased genotypes
    for i, (chrom, pos) in enumerate(positions):
        # bcftools view         View, subset and filter VCF or BCF files by position and filtering expression. Convert between VCF and BCF. Former bcftools subset.
        #
        # --no-header           suppress the header in VCF output
        # --regions             Comma-separated list of regions, see also -R, --regions-file. Note that -r cannot be used in combination with -R.
        # --phased              print sites where all samples are phased. Haploid genotypes are considered phased. Missing genotypes considered unphased unless the phased bit is set.
        # --trim-alt-alleles    trim alternate alleles not seen in subset. Type A, G and R INFO and FORMAT fields will also be trimmed
        # --exclude-uncalled    exclude sites without a called genotype
        # --samples-file        File of sample names to include or exclude if prefixed with "^". One sample per line.
        cmd = shlex.split('bcftools view --no-header --regions "{chrpos}" --phased --trim-alt-alleles --exclude-uncalled --samples-file {sample} {vcf}'.format(chrpos='{}:{}'.format(chrom, pos),
                                                                                                                                                               sample=sample,
                                                                                                                                                               vcf=glob.glob(vcf.format(chrom=chrom))[0]))

        results = subprocess.check_output(cmd, stderr=subprocess.STDOUT).splitlines()
        for result in results:
            records = result.split('\t')
            if records[0] == chrom and int(records[1]) == pos:
                break
        else:
            print >>sys.stderr, 'vcf record not found (error code NA1). chrom:{}, position:{}'.format(chrom, pos)
            sys.exit(0)

        if records == ['']:
            print >>sys.stderr, 'vcf record not found (error code NA2). chrom:{}, position:{}'.format(chrom, pos)
            sys.exit(0)

        rsid, ref, alt = records[2:5]
        alleles[i] = [ref] + alt.split(',')
        genotypes = list(chain.from_iterable([[int(x) for x in gt.split('|')] for gt in [a.split(':')[0] for a in records[9:]]]))

        if gt_matrix is None:
            gt_matrix = np.array(genotypes)
        else:
            gt_matrix = np.vstack((gt_matrix, np.array(genotypes)))

    c = Counter([tuple(gt_matrix[:,i]) for i in xrange(gt_matrix.shape[1])])

    if args.phased_allele_pair_only:
        # Get phased allele pair
        most_common_haplotypes = c.most_common(2)

        h1 = c.most_common(2)[0][0]
        h2 = c.most_common(2)[1][0]
        if h1[0] == h2[0] or h1[1] == h2[1]:
            print >>sys.stderr, 'ambiguous haplotypes (error code UM1). chrom:{}, position:{}, count:{}'.format(chrom, pos, c)
            sys.exit(0)

        phased_alleles = []
        for haplotype, count in most_common_haplotypes:
            for i, gt in enumerate(haplotype):
                phased_alleles.append(alleles[i][gt])

        # TODO: tri allele?

        # Abort if a1 == a2 or b1 == b2
        if phased_alleles[0] == phased_alleles[2] or phased_alleles[1] == phased_alleles[3]:
            print >>sys.stderr, 'ambiguous haplotypes (error code AM1). chrom:{}, position:{}, count:{}'.format(chrom, pos, c)
            sys.exit(0)

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
