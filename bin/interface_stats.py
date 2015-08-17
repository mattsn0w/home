#!/usr/local/bin/python


import os
import graphitesend


def formatLine(line):
    '''format each line from output to a graphite friendly metric.
    '''
    line = str(line).strip().split()
    action = line[0].split('/')[1].strip(':')
    direction = line[0].split('/')[0]
    packets = int(line[3])
    p =  'pf.%s.%s.packets' % (action, direction)
    bytes = int(line[5])
    b =  'pf.%s.%s.bytes' % (action, direction)
    results = { p : packets,
                b : bytes }
    return results


# Initial graphite sender. Set the server and change the detected FQDN to replace dots with underscores.
g = graphitesend.init(graphite_server='172.16.1.17', prefix='hosts', fqdn_squash=True)

# one of many ways to get a hostname. don't need it anymore.
#machine = os.uname()[1].split('.')[0]

# file that is generated before this script is run.
f = '/tmp/interface_re0.out'
fd = open(f, 'r')
lines = [ line for line in fd.readlines() ]
fd.close()


for line in lines:
    if line.strip().startswith('In') or line.strip().startswith('Out'):
        counters = formatLine(line)
        g.send_dict(counters)

