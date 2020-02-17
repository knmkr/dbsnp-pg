import logging
from decimal import *

from django.conf import settings
from django.db import connections

log = logging.getLogger('django')


class Snp(object):
    def __init__(self, pk):
        self.rsid = int(pk)

        # TODO:
        # raise ObjectDoesNotExist for invalid rsid

        self.dbsnp_build = settings.DBSNP_BUILD
        self.dbsnp_ref_genome_build = settings.DBSNP_REF_GENOME_BUILD

        self.chr_pos = self.get_all_pos_by_rs([self.rsid])
        self.refseq = self.get_refseq_by_rs([self.rsid])
        self.snp3d = self.get_snp3d_by_rs([self.rsid])
        self.omim = self.get_omim_by_rs([self.rsid])

    @classmethod
    def get_pos_by_rs(self, rsids):
        with connections['dbsnp'].cursor() as c:
            c.execute('SELECT * FROM get_pos_by_rs(%s)', (rsids,))
            row = dictfetchall(c)
            assert_query_ids_eq_result_ids(rsids, row)
            return row

    @classmethod
    def get_all_pos_by_rs(self, rsids):
        with connections['dbsnp'].cursor() as c:
            c.execute('SELECT * FROM get_all_pos_by_rs(%s)', (rsids,))
            row = dictfetchall(c)
            return row

    @classmethod
    def get_refseq_by_rs(self, rsids):
        with connections['dbsnp'].cursor() as c:
            c.execute('SELECT * FROM get_refseq_by_rs(%s)', (rsids,))
            row = dictfetchall(c)
            return row

    @classmethod
    def get_omim_by_rs(self, rsids):
        with connections['dbsnp'].cursor() as c:
            c.execute('SELECT * FROM get_omim_by_rs(%s)', (rsids,))
            row = dictfetchall(c)
            return row

    @classmethod
    def get_snp3d_by_rs(self, rsids):
        with connections['dbsnp'].cursor() as c:
            c.execute('SELECT * FROM get_snp3d_by_rs(%s)', (rsids,))
            row = dictfetchall(c)
            return row

    @classmethod
    def get_allele_freqs(self, source_id, rsids, af_order):
        with connections['dbsnp'].cursor() as c:
            try:
                c.execute('SELECT * FROM get_allele_freq(%s, %s)', (source_id, rsids,))
                rows = dictfetchall(c)
                assert_query_ids_eq_result_ids(rsids, rows)

                records = []
                for row in rows:
                    allele = row['allele'] or []
                    record = {
                        'snp_id':         row['snp_id'],
                        'snp_current':    row['snp_current'],
                        'ref':            row['ref'],
                        'allele':         ['' for i in range(len(allele))],
                        'freq':           ['' for i in range(len(allele))],
                        'freqx':          [],
                        'a1_hom_freq':    None,
                        'a1_a2_het_freq': None,
                        'a2_hom_freq':    None,
                    }

                    if allele:
                        # NOTE: only bi-allele is supported
                        assert len(allele) == 2

                        if self.af_order_dict().get(int(af_order)) == 'alphabet':
                            order_map = dict(zip(range(len(allele)), [allele.index(x) for x in sorted(allele)]))
                        else:
                            order_map = {0:0, 1:1}

                        for col in ['allele', 'freq']:
                            for i in range(len(allele)):
                                record[col][i] = row[col][order_map[i]]

                        if row['freqx']:
                            record['freqx'] = [None for i in range(6)]
                            if order_map == {0:0, 1:1}:
                                record['freqx'] = row['freqx']
                            elif order_map == {0:1, 1:0}:
                                record['freqx'][0] = row['freqx'][2] # flip A1 Hom Count
                                record['freqx'][1] = row['freqx'][1]
                                record['freqx'][2] = row['freqx'][0] # flip A2 Hom Count
                                record['freqx'][3] = row['freqx'][4] # flip A1 Hap Count
                                record['freqx'][4] = row['freqx'][3] # flip A2 Hap Count
                                record['freqx'][5] = row['freqx'][5]

                            gt_count = Decimal(record['freqx'][0] + record['freqx'][1] + record['freqx'][2])
                            record['a1_hom_freq']    = '{0: .4f}'.format(Decimal(record['freqx'][0]) / gt_count)
                            record['a1_a2_het_freq'] = '{0: .4f}'.format(Decimal(record['freqx'][1]) / gt_count)
                            record['a2_hom_freq']    = '{0: .4f}'.format(Decimal(record['freqx'][2]) / gt_count)

                    records.append(record)

                return records
            except Exception as e:
                log.warn(e)
                return []

    @classmethod
    def af_source_choices(self):
        with connections['dbsnp'].cursor() as c:
            try:
                c.execute("SELECT source_id, display_name FROM allelefreqsource WHERE status = 'ok' ORDER BY source_id")
                row = c.fetchall()
                return row
            except Exception as e:
                log.warn(e)
                return [(0, 'N/A')]

    @classmethod
    def af_order_choices(self):
        return [(0, 'minor'), (1, 'alphabet')]

    @classmethod
    def af_order_dict(self):
        return dict(self.af_order_choices())


def dictfetchall(cursor):
    '''Returns all rows from a cursor as a dict
    '''

    desc = cursor.description
    row = [dict(zip([col[0] for col in desc], [strip(v) for v in row])) for row in cursor.fetchall()]
    return row

def strip(x):
    if type(x) == str:
        return x.strip()
    else:
        return x

def assert_query_ids_eq_result_ids(query_ids, result_row):
    result_ids = [x['snp_id'] for x in result_row]
    assert query_ids == result_ids, '[ERROR] Query ids != Result ids: {} != {}'.format(query_ids, result_ids)

def is_frequences_installed():
    tables = connections['dbsnp'].introspection.table_names()
    return 'allelefreqsource' in tables
