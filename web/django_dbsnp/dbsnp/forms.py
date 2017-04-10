from django.conf import settings
from django import forms
from rest_framework import serializers
from .models import Snp

RSID_PLACEHOLDER = '''671
672
rs671
rs672
...
'''


class SnpsForm(forms.Form):
    rsids = forms.CharField(widget=forms.Textarea(attrs={'placeholder': RSID_PLACEHOLDER}))

    def clean_rsids(self):
        data = self.cleaned_data['rsids']
        return cleaned_rsids(data.splitlines())

class SnpsFreqForm(SnpsForm):
    af_population = forms.ChoiceField(widget=forms.widgets.Select, choices=Snp.af_source_choices())
    af_order = forms.ChoiceField(widget=forms.RadioSelect, choices=Snp.af_order_choices(), initial=0)


def cleaned_rsid(text):
    """
    >>> rsid('rs671')
    671
    """
    num = text.replace('rs', '')

    if len(num) > 9:
        raise forms.ValidationError('Too long string for rsID')

    try:
        rsid = int(num)
    except Exception as e:
        raise forms.ValidationError('Invalid string for rsID')

    return rsid

def cleaned_rsids(array):
    """
    >>> rsids(['rs671', 'rs672', 'rs673'])
    [671, 672, 673]
    """
    rsids = []

    for text in array:
        text = text.strip()
        if text:
            rsids.append(cleaned_rsid(text))

    if len(rsids) > settings.DBSNP_QUERY_COUNTS_LIMIT:
        msg = "Number of query exceeds soft limit {}".format(settings.DBSNP_QUERY_COUNTS_LIMIT)
        raise forms.ValidationError(msg)

    return rsids

def parse_rsids(request):
    q = request.GET.get('rsid', '').split(',')
    try:
        rsids = cleaned_rsids(q)
    except forms.ValidationError as e:
        raise serializers.ValidationError({'detail': e.message})
