import re
import csv
from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse
from django.conf import settings
from .models import SNP
from .forms import SnpsForm

def index(request):
    return redirect(snps)

def snps(request):
    form = SnpsForm(request.POST)
    context = {'form': form}

    if request.method == "POST":
        if form.is_valid():
            af_population = form.cleaned_data.get('af_population')
            rsids = form.cleaned_data.get('rsids')
            context['allele_freqs'] = SNP.get_allele_freqs(af_population, rsids)
            context['chr_pos'] = SNP.get_pos_by_rs(rsids)
        # TODO: show error messages for invalid queries

    return render(request, 'snps.html', context)

def snp(request, rsid):
    context = {'rsid': int(rsid)}

    context['chr_pos'] = SNP.get_all_pos_by_rs([context['rsid']])

    # TODO: gene

    # TODO: reference sequence

    # TODO: snp fasta sequence

    # TODO: JPT, EUR, AFR

    # TODO: OMIM

    # TODO: LD

    # TODO: GWAS

    context.update(
        {'dbsnp_build': settings.DBSNP_BUILD,
         'dbsnp_ref_genome_build': settings.DBSNP_REF_GENOME_BUILD,
    })

    fmt = request.GET.get('fmt', '')

    if fmt == 'json':
        response = JsonResponse(context)
        return response
    # elif fmt == 'tsv':
    #     # TODO: need to format nested context
    #     response = HttpResponse(content_type='text/tab-separated-values')
    #     response['Content-Disposition'] = 'attachment; filename="rs{}.tsv"'.format(rs)
    #     writer = csv.DictWriter(response, fieldnames=context.keys(), delimiter='\t')
    #     writer.writeheader()
    #     writer.writerow(context)
    #     return response
    else:
        return render(request, 'snp.html', context)
