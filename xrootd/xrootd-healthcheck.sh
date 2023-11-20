#!/bin/bash

# Check gridmap file existence & age
file=/etc/gateway/grid-mapfile
if [ -f $file ]; then
    lastModified=`echo $(($(date +%s) - $(date +%s -r $file)))`
    if [ $lastModified -gt 172800 ]; then
        echo "Gridmap file is too old (last modified $lastModified seconds ago)"
        exit 1
    fi
else
    echo "Gridmap file does not exist"
    exit 1
fi

# Check host certificate existence
if [ ! -s /etc/gateway/hostcert.pem ]; then
    echo "hostcert.pem doesn't exist or is zero-sized"
    exit 1
fi

if [ ! -s /etc/gateway/hostkey.pem ]; then
    echo "hostkey.pem doesn't exist or is zero-sized"
    exit 1
fi

# Check expiry
openssl x509 -checkend 7200 -noout -in /etc/gateway/hostcert.pem > /dev/null 2>&1
RC=$?
if [ $RC -gt 0 ]; then
    echo "Host certificate is about to expire"
    exit 1
fi

# Check for subject alt names
SANS=`openssl x509 -in /etc/gateway/hostcert.pem -noout -text | sed -ne '/Subject Alternative Name/{n;p}'`
if grep -v -q "DNS:\*.echo.stfc.ac.uk" <(echo $SANS); then
    echo "Host certificate does not contain required subject alt names"
    exit 1
fi

# Check the Ceph keyring
if [ ! -s /etc/ceph/ceph.client.xrootd.keyring ]; then
    echo "Ceph keyring doesn't exist or is zero-sized"
    exit 1
fi

# Monitor ports for both the gateway and proxy xrootd service.
# We only need one of these monitors to succeed for the check to pass
nc -z localhost 1094 || nc -z localhost 1095
if [ "$?" -ne 0 ]; then
    echo "Gateway does not listen the required port"
    exit 1
fi
# Check xrootd gateway stat
if [[ -z "${ISGATEWAY}" ]]; then
    echo "proxy - skipping read check"
else
    export XrdSecSSSKT=/etc/gateway/sss.keytab.grp
    fileno=$((RANDOM % 999))
    filename=$(printf 'dteam:test/test%04d' "$fileno")
    /usr/bin/xrdfs root://localhost:1095 stat $filename > /dev/null 2>&1
    if [ "$?" -ne 0 ]; then
      echo "Gateway failed to stat"
      exit 1
    fi
fi
netstatus=`ss | awk '{print $2}' | sort | uniq -c | sort -n | grep 'CLOSE' | awk '{print $1}'`
if [[ -z "${netstatus}" ]]; then
  echo "net ok"
else
  echo "${netstatus} close-waits found"
  if [[ $netstatus > 500 ]]; then
    exit 1
  fi
fi
exit 0
