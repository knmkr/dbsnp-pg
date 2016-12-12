from django.conf import settings
from django import forms
from .models import Snp

RSID_PLACEHOLDER = '''671
672
rs671
rs672
...
'''


class SnpsForm(forms.Form):
    af_population = forms.ChoiceField(widget=forms.widgets.Select, choices=Snp.af_source_choices())
    af_order = forms.ChoiceField(widget=forms.RadioSelect, choices=Snp.af_order_choices(), initial=0)
    rsids = forms.CharField(widget=forms.Textarea(attrs={'placeholder': RSID_PLACEHOLDER}))

    def clean_rsids(self):
        data = self.cleaned_data['rsids']
        lines = data.splitlines()

        data_cleaned = []
        try:
            for line in lines:
                text = line.strip()
                if text:
                    data_cleaned.append(rsid(text))
        except ValueError:
            raise forms.ValidationError("Invalid rs IDs")

        if len(data_cleaned) > settings.DBSNP_QUERY_COUNTS_LIMIT:
            raise forms.ValidationError("Number of query exceeds soft limit {}".format(settings.DBSNP_QUERY_COUNTS_LIMIT))

        return data_cleaned

def rsid(text):
    num = text.replace('rs', '')
    if len(num) > 9:
        raise ValueError()

    return int(num)
