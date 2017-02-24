from django.shortcuts import render
from django.conf import settings
from django import forms
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework import serializers
from .utils import table_exists
from .models import Snp
from .forms import SnpsForm, cleaned_rsids
from .serializers import SnpSerializer, ChrPosSerializer


def index(request):
    context = {}
    has_freq = table_exists('allelefreqsource')
    if has_freq:
        form = SnpsFreqForm(request.GET)
    else:
        form = SnpsForm(request.GET)

    if form.is_valid():
        af_population = form.cleaned_data.get('af_population')
        rsids = form.cleaned_data.get('rsids')
        af_order = form.cleaned_data.get('af_order')
        context['chr_pos'] = Snp.get_pos_by_rs(rsids)
        if has_freq:
            context['allele_freqs'] = Snp.get_allele_freqs(af_population, rsids, af_order)

    context.update({'form': form, 'has_freq': has_freq})
    return render(request, 'index.html', context)

def show(request, rsid):
    context = Snp(rsid).__dict__
    return render(request, 'show.html', context)

@api_view(['GET'])
def snp(request, pk, format=None):
    snp = Snp(pk)
    serializer = SnpSerializer(snp)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
def positions(request, format=None):
    q = request.GET.get('rsid', '').split(',')
    try:
        rsids = cleaned_rsids(q)
    except forms.ValidationError as e:
        raise serializers.ValidationError({'detail': e.message})

    positions = Snp.get_all_pos_by_rs(rsids)
    serializer = ChrPosSerializer(positions, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def frequences(request, format=None):
    has_freq = table_exists('allelefreqsource')
    if not has_freq:
        return Response({'msg': 'Not available'})

    # q = request.GET.get('rsid', '').split(',')
    # try:
    #     rsids = cleaned_rsids(q)
    # except forms.ValidationError as e:
    #     raise serializers.ValidationError({'detail': e.message})

    # af_population =
    # af_order =

    # frequences = Snp.get_allele_freqs
    return Response({'msg': 'Not implemented yet'})
