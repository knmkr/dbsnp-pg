from django.conf.urls import url
from . import views


urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^(\d{1,9})/$', views.show, name='show'),  # max rs ID is 483352819 (b141)
]
