#!/bin/sh
export XrdSecSSSKT=/etc/gateway/sss.keytab.grp
export LD_PRELOAD=/usr/lib64/libjemalloc.so.1
/usr/bin/xrootd -c /etc/xrootd/xrootd-ceph.cfg -k fifo -s /var/run/xrootd/xrootd-ceph.pid -n ceph
