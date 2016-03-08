from django import template

register = template.Library()

@register.filter
def css_class(value, arg):
    return value.as_widget(attrs={'class': arg})

@register.filter
def na(value):
    return value if value else 'N/A'
