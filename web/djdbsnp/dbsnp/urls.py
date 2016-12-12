from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^snps/$', views.snps, name='snps'),
    url(r'^snps/(\d{1,9})$', views.snp, name='snp'),  # max rs is 483352819 (b141)
]
