from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^snps/$', views.snps, name='snps'),
    url(r'^snp/(\d+)$', views.snp, name='snp'),
]
