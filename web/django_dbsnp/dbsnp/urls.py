from django.conf.urls import url
from . import views


urlpatterns = [
    url(r'^$', views.snps, name='index'),
    url(r'^(\d{1,9})/$', views.snp_detail, name='show'),  # max rs ID is 483352819 (b141)
]
