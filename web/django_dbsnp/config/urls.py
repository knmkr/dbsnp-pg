from django.conf.urls import url, include
from django.contrib import admin
from django.views.generic.base import RedirectView
from rest_framework.urlpatterns import format_suffix_patterns
from dbsnp import views as dbsnp_views


urlpatterns = [
    # url(r'^admin/', admin.site.urls),

    url(r'^$', RedirectView.as_view(pattern_name='dbsnp:index')),
    url(r'^dbsnp/', include('dbsnp.urls', namespace='dbsnp')),
]

api_urlpatterns = format_suffix_patterns([
    url(r'^api/v1/dbsnp/snps/(?P<pk>\d{1,9})/$', dbsnp_views.snp),
    url(r'^api/v1/dbsnp/positions/$', dbsnp_views.positions),
    url(r'^api/v1/dbsnp/frequences/$', dbsnp_views.frequences),
])

urlpatterns += api_urlpatterns
