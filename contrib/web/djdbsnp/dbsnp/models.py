import logging

from django.db import models
from django.db import connections

log = logging.getLogger('django')


class SNP(models.Model):
    @classmethod
    def get_chr_pos(self, rsids):
        with connections['dbsnp'].cursor() as c:
            c.execute('SELECT * FROM get_pos_by_rs(%s)', (rsids,))
            row = dictfetchall(c)
            _assert_query_ids_eq_result_ids(rsids, row)
            return row

    @classmethod
    def get_allele_freqs(self, source_id, rsids):
        with connections['dbsnp'].cursor() as c:
            try:
                c.execute('SELECT * FROM get_allele_freq(%s, %s)', (source_id, rsids,))
                row = dictfetchall(c)
                _assert_query_ids_eq_result_ids(rsids, row)
                return row
            except Exception as e:
                log.warn(e)
                return []

    @classmethod
    def get_af_sources(self):
        with connections['dbsnp'].cursor() as c:
            try:
                c.execute("SELECT source_id, display_name FROM allelefreqsource WHERE status = 'ok'")
                row = c.fetchall()
                return row
            except Exception as e:
                log.warn(e)
                return []

def dictfetchall(cursor):
    '''Returns all rows from a cursor as a dict
    '''

    desc = cursor.description
    row = [dict(zip([col[0] for col in desc], row)) for row in cursor.fetchall()]
    return row

def _assert_query_ids_eq_result_ids(query_ids, result_row):
    result_ids = [x['snp_id'] for x in result_row]
    assert query_ids == result_ids, '[ERROR] Query ids != Result ids: {} != {}'.format(query_ids, result_ids)
