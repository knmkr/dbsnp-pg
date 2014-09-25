#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re
import gzip
from pyfasta import Fasta

path_to_fasta = sys.argv[1]
path_to_bcp = sys.argv[2]

# GRCh37.p13
# $ wget -r ftp://ftp.ncbi.nlm.nih.gov/genbank/genomes/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh37.p13/Primary_Assembly/assembled_chromosomes/FASTA/
# $ for x in {1..22} X Y; do gzip -dc chr${x}.fa.gz >> GRCh37.p13.fa; done

# path_to_fasta = 'path_to_/GRCh37.p13.fa'
r = re.compile('Homo sapiens chromosome ([0-9XY]+),')
fasta = Fasta(path_to_fasta, key_fn=lambda key: r.search(key).group(1))

def get_allele(chrom, pos):
    return fasta.sequence({'chr': str(chrom), 'start': int(pos), 'stop': int(pos)}, one_based=True)


if __name__ == '__main__':
    # path_to_bcp = 'path_to_/b141_SNPChrPosOnRef_GRCh37p13.bcp.gz'  # GRCh37.p13
    # path_to_bcp = 'path_to_/b141_SNPChrPosOnRef.bcp.gz'  # GRCh38

    with gzip.open(path_to_bcp) as fin:
        for line in fin:
            record = line.split('\t')

            # No chrom & pos
            if record[1] in ('NotOn', 'Multi', 'Un'):
                print '\t'.join([record[0], record[1]])

            # chrom == Pseudoautosomal Region (PAR)
            elif record[1] == 'PAR':
                allele = get_allele('Y', int(record[2])+1)                             # chrom = Y (PAR)  # TODO: or skip?
                print '\t'.join([record[0], record[1], record[2], record[3], allele])

            # chrom == MT  # TODO: add chrMT.fa
            elif record[1] == 'MT':
                allele = ''
                print '\t'.join([record[0], record[1], record[2], record[3], allele])

            # No pos
            elif record[2] == '':
                print '\t'.join([record[0], record[1]])

            else:
                allele = get_allele(str(record[1]), int(record[2])+1)                  # 0-based to 1-based
                print '\t'.join([record[0], record[1], record[2], record[3], allele])  # snp_id, chr, pos(0-based), orien, allele
