#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import os
import glob
import argparse

from cmd import run, force, cd
from log import Logger
log = Logger(__name__)

VERSION = '0.5.4'
DBSNP_HOME = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--version', action='version', version='%(prog)s {}'.format(VERSION))
    subparsers = parser.add_subparsers()

    parser_init_demo = subparsers.add_parser('init-demo')
    parser_init_demo.add_argument('--db-name', default='dbsnp_demo', help='Demo database name')
    parser_init_demo.add_argument('--db-user', default='dbsnp_demo', help='Demo database user')
    parser_init_demo.set_defaults(func=init_demo)

    args = parser.parse_args()
    args.func(args)

def init_demo(args):
    context = {
        'db_user': args.db_user,
        'db_name': args.db_name,
    }

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

if __name__ == '__main__':
    main()
