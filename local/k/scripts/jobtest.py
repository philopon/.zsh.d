#!/usr/bin/env python2.7

import re
import sys
import tempfile
import shutil
import os
import subprocess
import threading
import time
import signal
import argparse


class Job(object):
    __slots__ = 'stgins', 'stgouts', 'script', 'stgdir', 'pjsub', 'path', 'orig_dir', 'o', 'e'

    def __init__(self, stgins, stgouts):
        self.stgins = stgins
        self.stgouts = stgouts
        self.pjsub = None

    def _info(self):
        for s, d in self.stgins:
            yield 'STGIN: ' + ','.join(s) + d

        for s, d in self.stgouts:
            yield 'STGOUT:' + ','.join(s) + d

        for line in self.script:
            yield 'SCRIPT:' + line.strip()

    def info(self):
        return '\n'.join(self._info())

    @classmethod
    def parse(cls, file):
        staging = re.compile(r'PJM *--stg(in|out) *["\'](.*)["\']')
        rank = re.compile(r'rank=')

        stgins = []
        stgouts = []
        script = []

        for line in file:
            script.append(line)

            stgmatch = staging.search(line)
            if stgmatch:
                src = [token.split(':')[-1]
                       for token in stgmatch.group(2).split()
                       if not rank.match(token)
                       ]
                dst = src[-1]
                src = src[:-1]

                dir = stgmatch.group(1)
                if dir == 'in':
                    stgins.append((src, dst))
                elif dir == 'out':
                    stgouts.append((src, dst))

        self = cls(stgins, stgouts)
        self.script = script
        return self

    def __repr__(self):
        return 'Job({!r},{!r})'.format(self.stgins, self.stgouts)

    def __enter__(self):
        self.stgdir = tempfile.mkdtemp(
            prefix=os.path.splitext(os.path.basename(__file__))[0] + '.',
            dir=os.path.expanduser('~/.cache')
        )
        return self

    def __exit__(self, *args, **kws):
        if self.pjsub is not None and self.pjsub.poll() is None:
            self.pjsub.terminate()
        shutil.rmtree(self.stgdir)

    def _stgin(self, src, dst):
        d = os.path.join(self.stgdir, dst)
        shutil.copy(src, d)

    def stgin(self):
        fd, self.path = tempfile.mkstemp(suffix='.sh', prefix='job', dir=self.stgdir)
        with os.fdopen(fd, 'w') as script:
            for line in self.script:
                script.write(line)

        for srcs, dst in self.stgins:
            for src in srcs:
                self._stgin(src, dst)

    def chdir(self):
        self.orig_dir = os.getcwd()
        os.chdir(self.stgdir)

    def submit(self, node=1, elapse=3600, wait_time=3600):
        cmd = [
            'pjsub', '--interact',
            '--rsc-list', 'node={}'.format(node),
            '--mpi', 'proc={}'.format(node),
            '--rsc-list', 'elapse={}'.format(elapse),
            '--sparam', 'wait-time={}'.format(wait_time),
            '--rsc-list', 'rscgrp=interact',
            self.path
        ]

        self.pjsub = p = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )

        self.o = threading.Thread(target=print_log, args=(p.stdout, sys.stdout))
        self.e = threading.Thread(target=print_log, args=(p.stderr, sys.stderr))
        self.o.daemon = True
        self.e.daemon = True
        self.o.start()
        self.e.start()

    def watch(self, file):
        t = threading.Thread(target=file_watch, args=(file, sys.stdout))
        t.daemon = True
        t.start()
        return t

    def watch_stgouts(self):
        return [self.watch(src) for srcs, _ in self.stgouts for src in srcs]

    def stgout(self):
        print('{0} STGOUT {0}'.format('-' * 30))
        for srcs, dst in self.stgouts:
            for src in srcs:
                if os.path.isfile(src):
                    print('stgout: {} to {}'.format(src, dst))
                    shutil.copy(src, os.path.join(self.orig_dir, dst))
                else:
                    sys.stderr.write('{}: not exists\n'.format(src))


def file_watch(src, dst):
    if os.path.isfile(src):
        file = open(src)
    else:
        time.sleep(0.1)
        return file_watch(src, dst)

    while True:
        line = file.readline()
        if line:
            dst.write(src + '|' + line)
        else:
            time.sleep(0.1)

def print_log(src, dst):
    with src:
        while True:
            line = src.readline()
            if line:
                dst.write(line)
            else:
                break

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('script', metavar='SCRIPT', type=argparse.FileType('r'), help='job script file')
    parser.add_argument('--node', '-n', metavar='N', type=int, help='node count (default: %(default)s)', default=1)
    parser.add_argument('--elapse', '-e', metavar='SEC', type=int, help='elapse time (default: %(default)s)', default=3600)
    parser.add_argument('--wait', metavar='SEC', type=int, help='wait time (default: %(default)s)', default=3600)
    parser.add_argument('--watch', '-w', metavar='FILE', type=str, help='watch file (default: stgouts)', nargs='*', default=None)
    parser.add_argument('--info', '-i', type=bool, help='print jobtest information', default=False)

    args = parser.parse_args()

    with Job.parse(args.script) as job:
        if args.info:
            print(job.info())

        def handler(signal, frame):
            job.pjsub.terminate()
            job.pjsub.wait()
            job.stgout()
            sys.exit(1)

        signal.signal(signal.SIGINT, handler)

        job.stgin()
        job.chdir()
        job.submit(node=args.node, elapse=args.elapse, wait_time=args.wait)

        if args.watch is None:
            job.watch_stgouts()
        else:
            for w in args.watch:
                job.watch(w)

        job.pjsub.wait()
        job.stgout()

if __name__ == '__main__':
    main()
