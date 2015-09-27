#!/usr/local/bin/bash

/sbin/pfctl -i re0 -s Interfaces -vv > /tmp/interface_re0.out
/home/msnow/bin/interface_stats.py

