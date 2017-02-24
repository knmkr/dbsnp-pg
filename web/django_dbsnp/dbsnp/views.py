import json
from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from django import forms
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework import generics
from rest_framework import serializers
from .models import Snp
from .forms import SnpsForm, cleaned_rsids
from .serializers import SnpSerializer, ChrPosSerializer


@api_view(['GET'])
def snp(request, pk, format=None):
    snp = Snp(pk)
    serializer = SnpSerializer(snp)
    return Response(serializer.data, status=status.HTTP_200_OK)

def snp_detail(request, rsid):
    context = Snp(rsid).__dict__
    return render(request, 'snp.html', context)

@api_view(['GET'])
def positions(request, format=None):
    q = request.GET.get('rsid', '').split(',')
    try:
        rsids = cleaned_rsids(q)
    except forms.ValidationError as e:
        raise serializers.ValidationError({'detail': e.message})

    positions = Snp.get_pos_by_rs(rsids)
    serializer = ChrPosSerializer(positions, many=True)
    return Response(serializer.data)

# @api_view(['GET'])
# def frequences(request, format=None):
#     pass

# TODO: rewrite in DRF
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

            context['allele_freqs'] = Snp.get_allele_freqs(af_population, rsids, af_order)
            context['chr_pos'] = Snp.get_pos_by_rs(rsids)
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
                context['allele_freqs'] = Snp.get_allele_freqs(af_population, rsids, af_order)
                context['chr_pos'] = Snp.get_pos_by_rs(rsids)
            context['form'] = form

        return render(request, 'snps.html', context)
