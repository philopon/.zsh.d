#!/usr/bin/env python2

cpus = dict()
pid, cores = None, None

for line in open('/proc/cpuinfo'):
    if 'physical id' in line:
        pid = int(line.split(':')[1])
    elif  'cpu cores' in line:
        cores = int(line.split(':')[1])

    if pid is not None and cores is not None:
        cpus[pid] = cores
        pid, cores = None, None

print sum(cpus.itervalues())
