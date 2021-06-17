FROM centos:7

# xrootd user - needs to be consistent with the host
RUN groupadd --gid 65432 xrootd && \
    useradd --gid xrootd --uid 65432 xrootd

# Repositories
COPY *.repo /etc/yum.repos.d/

# Ceph
RUN yum -y install ceph-14.2.15-0.el7.x86_64 \
                   ceph-common-14.2.15-0.el7.x86_64

# xrootd
RUN yum -y install xrootd-ceph \
                   xrootd-client \
                   xrootd-client-libs \
                   xrootd-libs \
                   xrootd-server \
                   xrootd-server-libs \
                   jemalloc

# For N2N mapping
RUN yum -y install http://repos.gridpp.rl.ac.uk/yum/xrootd-cmstfc/el7/xrootd-cmstfc-1.5.2-6.osgup.el7.x86_64.rpm

# Needed by the health-check scripts
RUN yum -y install openssl

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
