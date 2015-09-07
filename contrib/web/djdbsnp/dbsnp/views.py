import csv
from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.conf import settings
from .models import SNP


def index(request):
    rs = 671
    chrom, pos = SNP.get_pos_by_rs(rs)
    # TODO: chrom, pos on b37, b38

    # TODO: gene

    # TODO: reference sequence

    # TODO: snp fasta sequence

    rs_current = SNP.get_current_rs(rs)

    allele_freq_source = '1000 Genomes Phase1, CHB+JPT+CHS'  # TODO
    allele_freq_source_id = 1  # TODO
    af = SNP.get_allele_freq(allele_freq_source_id, rs)
    allele_freqs = {allele_freq_source: dict(zip(af['allele'], af['freq']))}

    # TODO: JPT, EUR, AFR

    # TODO: OMIM

    # TODO: LD

    # TODO: GWAS

    records = {'dbsnp_build': settings.DBSNP_BUILD,
               'dbsnp_ref_genome_build': settings.DBSNP_REF_GENOME_BUILD,
               'rs': rs,
               'chrom': chrom,
               'pos': pos,
               'rs_current': rs_current,
               'allele_freqs': allele_freqs}

    fmt = request.GET.get('fmt', '')

    if fmt == 'json':
        response = JsonResponse(records)
        return response
    elif fmt == 'tsv':
        # TODO: need to format nested records (allele freqs)
        response = HttpResponse(content_type='text/tab-separated-values')
        response['Content-Disposition'] = 'attachment; filename="rs{}.tsv"'.format(rs)
        writer = csv.DictWriter(response, fieldnames=records.keys(), delimiter='\t')
        writer.writeheader()
        writer.writerow(records)
        return response
    else:
        return render(request, 'index.html', records)
