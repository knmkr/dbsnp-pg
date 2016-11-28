import re
import csv
import json
from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from .models import SNP
from .forms import SnpsForm


def index(request):
    return redirect(snps)

@csrf_exempt  # FIXME: change to GET?
def snps(request):
    fmt = request.GET.get('fmt', '')

    if fmt == 'json':
        context = {}
        if request.method == "POST":
            # FIXME: need to validate params
            data = json.loads(request.body)
            af_population = data.get('af_population')
            rsids = data.get('rsids')
            af_order = data.get('af_order')

            context['allele_freqs'] = SNP.get_allele_freqs(af_population, rsids, af_order)
            context['chr_pos'] = SNP.get_pos_by_rs(rsids)
        response = JsonResponse(context)

        return response

    else:
        form = SnpsForm()
        context = {'form': form}
        if request.method == "POST":
            form = SnpsForm(request.POST)
            if form.is_valid():
                af_population = form.cleaned_data.get('af_population')
                rsids = form.cleaned_data.get('rsids')
                af_order = form.cleaned_data.get('af_order')
                context['allele_freqs'] = SNP.get_allele_freqs(af_population, rsids, af_order)
                context['chr_pos'] = SNP.get_pos_by_rs(rsids)
            context['form'] = form

        return render(request, 'snps.html', context)

def snp(request, rsid):
    context = {
        'rsid': int(rsid),
        'dbsnp_build': settings.DBSNP_BUILD,
        'dbsnp_ref_genome_build': settings.DBSNP_REF_GENOME_BUILD,
    }

    context['chr_pos'] = SNP.get_all_pos_by_rs([context['rsid']])

    # TODO: gene

    context['refseq'] = SNP.get_refseq_by_rs([context['rsid']])

    # TODO: snp fasta sequence

    context['snp3d'] = SNP.get_snp3d_by_rs([context['rsid']])
    context['omim'] = SNP.get_omim_by_rs([context['rsid']])

    # TODO: LD

    # TODO: GWAS

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
