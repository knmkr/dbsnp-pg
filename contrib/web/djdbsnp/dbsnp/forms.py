from django import forms

class SnpsForm(forms.Form):
    rsids = forms.CharField(widget=forms.Textarea)

    def clean_rsids(self):
        data = self.cleaned_data['rsids']
        lines = data.splitlines()

        try:
            data_cleaned = [int(line.replace('rs', '')) for line in lines]
        except ValueError:
            raise forms.ValidationError("Invalid rs IDs")

        return data_cleaned
