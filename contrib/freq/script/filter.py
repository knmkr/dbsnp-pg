#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re
import argparse

def _rsid(text):
    pattern = re.compile('rs(\d+)')
    rs_match = pattern.match(text)

    if rs_match:
        return int(rs_match.group(1))
    else:
        return None

def _main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--source-id', required=True, type=str)
    args = parser.parse_args()

    for line in sys.stdin:
        record = line.strip().split('\t')
        rsid = _rsid(record[0])
        if not rsid:
            continue
        print '\t'.join([str(rsid)] + record[1:] + [args.source_id])

if __name__ == '__main__':
    _main()
