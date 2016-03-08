from django import forms

AF_POPULATION_CHOICES = (
    (3,   '1000 Genomes Phase1 CHB+JPT+CHS'),
    (0,   '-------------------------------'),
    (4,   '1000 Genomes Phase3 CHB+JPT+CHS'),
    (100, '1000 Genomes Phase3 CEU'),
    (200, '1000 Genomes Phase3 YRI'),
    (300, '1000 Genomes Phase3 Global'),
)

class SnpsForm(forms.Form):
    af_population = forms.ChoiceField(widget=forms.widgets.Select, choices=AF_POPULATION_CHOICES)
    rsids = forms.CharField(widget=forms.Textarea)

    def clean_rsids(self):
        data = self.cleaned_data['rsids']
        lines = data.splitlines()

        try:
            data_cleaned = [int(line.replace('rs', '')) for line in lines]
        except ValueError:
            raise forms.ValidationError("Invalid rs IDs")

        return data_cleaned
