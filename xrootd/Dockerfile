FROM rockylinux:8
ARG XROOTD_VERSION=5.7.1-3
ARG XRDCEPH_VERSION=5.7.1-3
ARG CEPH_VERSION=14.2.22-0
LABEL xrootd-ver=$XROOTD_VERSION
LABEL xrdceph-ver=$XRDCEPH_VERSION
LABEL ceph-ver=$CEPH_VERSION

# xrootd user - needs to be consistent with the host
RUN groupadd --gid 65432 xrootd && \
    useradd --gid xrootd --uid 65432 xrootd

# Repositories
COPY *.repo /etc/yum.repos.d/

# install versionlock, and configure versionlocks
RUN dnf -y install python3-dnf-plugin-versionlock
RUN dnf -y versionlock add ceph-${CEPH_VERSION}.el8.x86_64 \
                           ceph-base-${CEPH_VERSION}.el8.x86_64 \
                           ceph-common-${CEPH_VERSION}.el8.x86_64 \
                           ceph-mds-${CEPH_VERSION}.el8.x86_64 \
                           ceph-mgr-${CEPH_VERSION}.el8.x86_64 \
                           ceph-mon-${CEPH_VERSION}.el8.x86_64 \
                           ceph-osd-${CEPH_VERSION}.el8.x86_64 \
                           ceph-selinux-${CEPH_VERSION}.el8.x86_64 \
                           libcephfs2-${CEPH_VERSION}.el8.x86_64 \
                           librados2-${CEPH_VERSION}.el8.x86_64 \
                           libradosstriper1-${CEPH_VERSION}.el8.x86_64 \
                           librbd1-${CEPH_VERSION}.el8.x86_64 \
                           librgw2-${CEPH_VERSION}.el8.x86_64 \
                           python-ceph-argparse-${CEPH_VERSION}.el8.x86_64 \
                           python-cephfs-${CEPH_VERSION}.el8.x86_64 \
                           python-rados-${CEPH_VERSION}.el8.x86_64 \
                           python-rbd-${CEPH_VERSION}.el8.x86_64 \
                           python-rgw-${CEPH_VERSION}.el8.x86_64 \
                           python3-ceph-argparse-${CEPH_VERSION}.el8.x86_64 \
                           python3-cephfs-${CEPH_VERSION}.el8.x86_64 \
                           python3-rados-${CEPH_VERSION}.el8.x86_64 \
                           python3-rbd-${CEPH_VERSION}.el8.x86_64 \
                           python3-rgw-${CEPH_VERSION}.el8.x86_64 \
                           xrootd-${XROOTD_VERSION}.el8.x86_64 \
                           xrootd-client-${XROOTD_VERSION}.el8.x86_64 \
                           xrootd-client-libs-${XROOTD_VERSION}.el8.x86_64 \
                           xrootd-libs-${XROOTD_VERSION}.el8.x86_64 \
                           xrootd-selinux-${XROOTD_VERSION}.el8.noarch \
                           xrootd-server-${XROOTD_VERSION}.el8.x86_64 \
                           xrootd-server-libs-${XROOTD_VERSION}.el8.x86_64 \
                           xrootd-ceph-buffered-${XRDCEPH_VERSION}.el8.x86_64 \
                           xrootd-voms-${XROOTD_VERSION}.el8.x86_64

RUN dnf -y versionlock list


# Ceph
RUN dnf -y install ceph \
                   ceph-common

# xrootd
RUN dnf -y install xrootd-ceph-buffered \
                   xrootd-client \
                   xrootd-client-libs \
                   xrootd-libs \
                   xrootd-server \
                   xrootd-server-libs \
                   xrootd-voms \
                   jemalloc


# For N2N mapping
RUN dnf -y install http://repos.gridpp.rl.ac.uk/yum/xrootd-cmstfc/el8/xrootd-cmstfc-1.5.2-6.osgroup.el8.x86_64.rpm

# Needed by the health-check scripts
RUN dnf -y install openssl

# python3 needed for cephsum script
RUN dnf -y install python3 \
                   python3-rados

# Install netcat for service healthcheck
RUN dnf -y install netcat

# Update & cleanup
RUN dnf -y update && \
                   dnf clean all && \
                   rm -rf /var/cache/dnf

# Bake healthcheck script
COPY xrootd-healthcheck.sh .
HEALTHCHECK --interval=180s --timeout=10s --retries=2 \
    CMD bash xrootd-healthcheck.sh

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
