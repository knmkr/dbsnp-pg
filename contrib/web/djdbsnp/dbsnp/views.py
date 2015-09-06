from django.shortcuts import render
from django.conf import settings
from .models import SNP

def index(request):
    rs = str(671)
    chrom, pos = SNP.get_pos_by_rs(rs)
    # TODO: chrom, pos on b37, b38

    # TODO: gene

    # TODO: reference sequence

    # TODO: snp fasta sequence

    rs_current = SNP.get_current_rs(rs)

    # TODO: freq
    # - alleles, freq, source
    # - EAS, EUR, AFR

    # TODO: OMIM

    # TODO: LD

    # TODO: GWAS

    return render(request, 'index.html',
                  {'dbsnp_build': settings.DBSNP_BUILD,
                   'dbsnp_ref_genome_build': settings.DBSNP_REF_GENOME_BUILD,
                   'rs': rs,
                   'chrom': chrom,
                   'pos': pos,
                   'rs_current': rs_current})
