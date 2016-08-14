from django.conf import settings
from django import forms
from .models import SNP

RSID_PLACEHOLDER = '''671
672
rs671
rs672
...
'''


class SnpsForm(forms.Form):
    choices = SNP.get_af_sources() or [(0, 'N/A')]
    af_population = forms.ChoiceField(widget=forms.widgets.Select, choices=choices)
    rsids = forms.CharField(widget=forms.Textarea(attrs={'placeholder': RSID_PLACEHOLDER}))

    def clean_rsids(self):
        data = self.cleaned_data['rsids']
        lines = data.splitlines()

        try:
            data_cleaned = [int(line.replace('rs', '')) for line in lines]
        except ValueError:
            raise forms.ValidationError("Invalid rs IDs")

        if len(data_cleaned) > settings.DBSNP_QUERY_COUNTS_LIMIT:
            raise forms.ValidationError("Number of query exceeds soft limit {}".format(settings.DBSNP_QUERY_COUNTS_LIMIT))

        return data_cleaned
