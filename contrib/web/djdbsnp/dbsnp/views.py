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
    records = {'allele_freqs': None}

    if request.method == "POST":
        form = SnpsForm(request.POST)
        if form.is_valid():
            allele_freq_source_id = 4  # TODO
            rsids = form.cleaned_data.get('rsids')
            af = SNP.get_allele_freqs(allele_freq_source_id, rsids)
            records['allele_freqs'] = af
            records['chr_pos'] = SNP.get_chr_pos(af.keys())

        # TODO: show error messages for invalid queries

    return render(request, 'snps.html', records)

def snp(request):
    rs_regexp = re.compile('\A(rs)?(\d{1,9})\Z')  # max rs# is 483352819 (b141)
    rs_match = rs_regexp.findall(request.GET.get('rs', ''))
    rs = int(rs_match[0][1]) if rs_match else ''
    records = {'rs': rs}

    # TODO: handle not found records
    if rs:
        chrom, pos = SNP.get_pos_by_rs(rs)
        # TODO: chrom, pos on b37, b38

        # TODO: gene

        # TODO: reference sequence

        # TODO: snp fasta sequence

        rs_current = SNP.get_current_rs(rs)

        allele_freq_source = '1000 Genomes Phase1, CHB+JPT+CHS'  # TODO
        allele_freq_source_id = 1  # TODO
        af = SNP.get_allele_freqs(allele_freq_source_id, [rs])
        allele_freqs = {allele_freq_source: dict(zip(af['allele'], af['freq']))}

        # TODO: JPT, EUR, AFR

        # TODO: OMIM

        # TODO: LD

        # TODO: GWAS

        records.update({'dbsnp_build': settings.DBSNP_BUILD,
                        'dbsnp_ref_genome_build': settings.DBSNP_REF_GENOME_BUILD,
                        'rs': rs,
                        'chrom': chrom,
                        'pos': pos,
                        'rs_current': rs_current,
                        'allele_freqs': allele_freqs})

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
        return render(request, 'snp.html', records)
