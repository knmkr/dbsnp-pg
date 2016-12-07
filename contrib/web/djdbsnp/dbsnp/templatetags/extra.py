from django import template

register = template.Library()

@register.filter
def css_class(value, arg):
    return value.as_widget(attrs={'class': arg})

@register.filter
def na(value):
    return 'N/A' if value is None or value == '' else value

@register.filter
def fwd_or_rev(value):
    if value == 0:
        return 'Fwd'
    elif value == 1:
        return 'Rev'
    else:
        return 'N/A'
