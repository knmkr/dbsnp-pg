#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import os
import glob
import argparse
from pprint import pformat

from lib.termcolor import colored
from cmd import run, force, cd
from log import Logger
log = Logger(__name__)

DBSNP_HOME = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DBSNP_BUILDS = ['b147', 'b146', 'b144']
DBSNP_DEFAULT = 'b146'
GENOME_BUILDS = ['GRCh38', 'GRCh37']
GENOME_DEFAULT = 'GRCh37'
VERSION = open(os.path.join(DBSNP_HOME, 'VERSION')).readline().strip()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--version', action='version', version='%(prog)s {}'.format(VERSION))
    parser.add_argument('--dbsnp-build', default=DBSNP_DEFAULT, choices=DBSNP_BUILDS, help='dbSNP build ID')
    parser.add_argument('--genome-build', default=GENOME_DEFAULT, choices=GENOME_BUILDS, help='reference genome build ID')

    subparsers = parser.add_subparsers()
    parser_restore = subparsers.add_parser('restore', help='restore database from pg_dump')
    parser_restore.add_argument('--tag', default=VERSION, help='dbsnp-pg release tag')
    parser_restore.set_defaults(func=restore)
    parser_build = subparsers.add_parser('build', help='build database from resources')
    parser_build.set_defaults(func=build)
    parser_init_demo = subparsers.add_parser('init-demo', help='init demo database')
    parser_init_demo.add_argument('--demo-db-name', default='dbsnp_demo', help='demo database name')
    parser_init_demo.add_argument('--demo-db-user', default='dbsnp_demo', help='demo database user')
    parser_init_demo.set_defaults(func=init_demo)

    args = parser.parse_args()
    args.func(args)

def restore(args):
    context = {
        'dbsnp_build': args.dbsnp_build,
        'genome_build': args.genome_build,
        'tag': args.tag,
    }
    context['db_name'] = 'dbsnp_{dbsnp_build}_{genome_build}'.format(**context)
    context['db_user'] = 'dbsnp'
    log.info(colored(pformat(context), 'blue'))

    with cd(DBSNP_HOME):
        force('createuser {db_user}'.format(**context))
        run('./script/pg_restore.sh {db_name} {db_user} {tag}'.format(**context))

    log.info('Done')
    log.info('To connect via psql, run:')
    log.info('')
    log.info(colored('$ psql {db_name} -U {db_user}'.format(**context), 'blue', attrs=['bold']))
    log.info('')

def build(args):
    context = {
        'dbsnp_build': args.dbsnp_build,
        'genome_build': args.genome_build,
    }
    context['db_name'] = 'dbsnp_{dbsnp_build}_{genome_build}'.format(**context)
    context['db_user'] = 'dbsnp'
    log.info(colored(pformat(context), 'blue'))

    with cd(DBSNP_HOME):
        force('createuser {db_user}'.format(**context))
        force('createdb --owner={db_user} {db_name}'.format(**context))

        for src in [DBSNP_HOME] + glob.glob(DBSNP_HOME + '/contrib/*'):
            with cd(src):
                run('pwd')
                if glob.glob('02_drop_create_table.*'):
                    context.update(src=src)
                    run('./01_fetch_data.sh        -d {dbsnp_build} -r {genome_build} {src}/data'.format(**context))
                    run('./02_drop_create_table.sh {db_name} {db_user} {src}'.format(**context))
                    run('./03_import_data.sh       {db_name} {db_user} {src} {src}/data'.format(**context))

    log.info('Done')
    log.info('To connect via psql, run:')
    log.info('')
    log.info(colored('$ psql {db_name} -U {db_user}'.format(**context), 'blue', attrs=['bold']))
    log.info('')

def init_demo(args):
    context = {
        'db_user': args.demo_db_user,
        'db_name': args.demo_db_name,
    }
    log.info(colored(pformat(context), 'blue'))

    with cd(DBSNP_HOME):
        force('createuser {db_user}'.format(**context))
        force('createdb --owner={db_user} {db_name}'.format(**context))

        for src in [DBSNP_HOME] + glob.glob(DBSNP_HOME + '/contrib/*'):
            with cd(src):
                run('pwd')
                if glob.glob('02_drop_create_table.*'):
                    context.update(src=src)
                    run('./02_drop_create_table.sh {db_name} {db_user} {src}'.format(**context))
                    run('./03_import_data.sh       {db_name} {db_user} {src} {src}/test/data'.format(**context))

    log.info('Done')
    log.info('To connect via psql, run:')
    log.info('')
    log.info(colored('$ psql {} -U {}'.format(args.demo_db_name, args.demo_db_user), 'blue', attrs=['bold']))
    log.info('')

if __name__ == '__main__':
    main()
