from django.db import models
from django.db import connections


class SNP(models.Model):
    @classmethod
    def get_pos_by_rs(self, rs):
        with connections['dbsnp'].cursor() as c:
            c.execute("SELECT * FROM get_tbl_pos_by_rs(%s)", [rs])
            row = dictfetchall(c)
            return row

    @classmethod
    def get_freq_by_rs(self, rs):
        with connections['dbsnp'].cursor() as c:
            c.execute("SELECT snp_id,ref,alt,freq_eas FROM allelefreqin1000genomesphase3 WHERE snp_id = %s", [rs])
            row = dictfetchall(c)
            return row


def dictfetchall(cursor):
    "Returns all rows from a cursor as a dict"
    desc = cursor.description
    return [
        dict(zip([col[0] for col in desc], row))
        for row in cursor.fetchall()
    ]
