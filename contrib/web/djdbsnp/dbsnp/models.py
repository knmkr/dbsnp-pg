from django.db import models
from django.db import connections


class SNP(models.Model):
    @classmethod
    def get_pos_by_rs(self, rs):
        with connections['dbsnp'].cursor() as c:
            c.execute("SELECT * FROM get_tbl_pos_by_rs(%s)", (rs,))
            row = c.fetchone()
            return row[0], row[1]

    @classmethod
    def get_current_rs(self, rs):
        with connections['dbsnp'].cursor() as c:
            c.execute("SELECT get_current_rs(%s)", (rs,))
            row = c.fetchone()
            return row[0]

    @classmethod
    def get_allele_freqs(self, source_id, rsids):
        with connections['dbsnp'].cursor() as c:
            c.execute("SELECT * FROM get_tbl_allele_freq_by_rs_history(%s, %s)", (source_id, rsids,))
            row = dictfetchall(c)
            return row


def dictfetchall(cursor):
    "Returns all rows from a cursor as a dict"
    desc = cursor.description
    return [
        dict(zip([col[0] for col in desc], row))
        for row in cursor.fetchall()
    ]
