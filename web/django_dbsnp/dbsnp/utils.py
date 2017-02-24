from django.db import connections


def table_exists(table):
    return table in connections['dbsnp'].introspection.table_names()
