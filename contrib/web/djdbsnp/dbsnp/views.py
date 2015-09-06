from django.shortcuts import render
from .models import SNP

def index(request):
    #
    rs = str(671)
    chrpos = SNP.get_pos_by_rs(rs)

    return render(request, 'index.html', dict(rs=rs, chrpos=chrpos))
