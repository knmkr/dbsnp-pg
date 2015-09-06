from django.shortcuts import render
from django.conf import settings
from .models import SNP

def index(request):
    rs = str(671)
    chrpos = SNP.get_pos_by_rs(rs)
    # TODO: chrom, pos on b37, b38

    # TODO: gene

    # TODO: reference sequence

    # TODO: snp fasta sequence

    # TODO: rs id history
    # - rshigh, rslow, rscurrent

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
                   'chrpos': chrpos})
