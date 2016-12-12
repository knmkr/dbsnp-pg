from django.conf.urls import url
from rest_framework.urlpatterns import format_suffix_patterns

from . import views

urlpatterns = [
    #
    url(r'^snps/$', views.snps, name='snps'),
    url(r'^snps/(\d{1,9})/$', views.snp, name='snp'),  # max rs ID is 483352819 (b141)

    # API endpoints
    url(r'^api/v1/$', views.api_root),
    url(r'^api/v1/snps/$', views.SnpList.as_view(), name='snp-list'),
    url(r'^api/v1/snps/(?P<pk>\d{1,9})/$', views.SnpDetail.as_view(), name='snp-detail'),
]

urlpatterns = format_suffix_patterns(urlpatterns)
