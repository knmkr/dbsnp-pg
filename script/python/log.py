import logging

from lib.termcolor import colored


# git://gist.github.com/1238935.git
class Logger(object):
    def __init__(self, name):
        self.color_map = {'debug': {'color': 'grey', 'attrs': ['bold']},
                          'info':  {'color': 'white'},
                          'warn':  {'color': 'yellow', 'attrs': ['bold']},
                          'error': {'color': 'red'},
                          'fatal': {'color': 'red', 'attrs': ['bold']},
        }
        self.logger = logging.getLogger(name)
        self.logger.setLevel(logging.INFO)
        self.stdout = logging.StreamHandler()
        self.stdout.setLevel(logging.INFO)
        self.stdout.setFormatter(logging.Formatter('%(asctime)s [%(levelname)s] %(message)s', '%Y-%m-%d %H:%M:%S'))
        self.logger.addHandler(self.stdout)

    def __getattr__(self, status, attrs=[]):
        if status in ('debug', 'info', 'warn', 'error', 'fatal'):
            return lambda msg, *args: getattr(self.logger, status)(
                colored(msg, **self.color_map[status]), *args)
