FROM centos:7

# xrootd user - needs to be consistent with the host
RUN groupadd --gid 65432 xrootd && useradd --gid xrootd --uid 65432 xrootd

# Repositories
COPY *.repo /etc/yum.repos.d/

# Ceph
RUN yum -y install ceph-11.2.1-0.el7.x86_64 \
                   ceph-common-11.2.1-0.el7.x86_64

# Memory allocation
RUN yum -y install jemalloc

# xrootd
RUN yum -y install xrootd-ceph-20170724.06470a6-2.el7.x86_64 \
                   xrootd-client-20170724.06470a6-2.el7.x86_64 \
                   xrootd-client-libs-20170724.06470a6-2.el7.x86_64 \
                   xrootd-libs-20170724.06470a6-2.el7.x86_64 \
                   xrootd-server-20170724.06470a6-2.el7.x86_64 \
                   xrootd-server-libs-20170724.06470a6-2.el7.x86_64

# For N2N mapping
RUN yum -y install http://t2.unl.edu/store/osg/3.4/el7/contrib/x86_64/xrootd-cmstfc-1.5.1-11.osg34.el7.x86_64.rpm

# Needed by the health-check scripts
RUN yum -y install openssl

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
