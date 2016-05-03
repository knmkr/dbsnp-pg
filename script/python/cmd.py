import os
import shlex
import subprocess
from contextlib import contextmanager

from lib.termcolor import colored
from log import Logger
log = Logger(__name__)


def run(cmd):
    log.info(colored('$ {}'.format(cmd), 'green', attrs=['bold', 'underline']))
    log.info(subprocess.check_output(shlex.split(cmd), stderr=subprocess.STDOUT).strip())

def force(cmd):
    try:
        run(cmd)
    except subprocess.CalledProcessError as e:
        log.warn(e.output.strip())

@contextmanager
def cd(path):
    prev = os.getcwd()
    os.chdir(os.path.expanduser(path))
    try:
        yield
    finally:
        os.chdir(prev)
