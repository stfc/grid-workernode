FROM rockylinux:8

# Add labels and arguments
ARG XROOTD_VERSION=5.7.3-3
ARG XRDCEPH_VERSION=5.7.3-3
ARG CEPH_VERSION=16.2.15-0

ARG ARCH=x86_64
ARG DISTRO=el8
LABEL xrootd-ver=$XROOTD_VERSION
LABEL xrdceph-ver=$XRDCEPH_VERSION
LABEL ceph-ver=$CEPH_VERSION
LABEL org.opencontainers.image.source=https://github.com/stfc/grid-workernode
LABEL org.opencontainers.image.authors=gstsm@stfc.atlassian.net
LABEL org.opencontainers.image.description="A specialised container image optimised as a local XROOTD gateway in RAL's computing environment. \
It includes software for XROOTD along with libraries, and dependencies, ensuring efficient, and scalable data staging, benefiting researchers and organisations."

# xrootd user - needs to be consistent with the host
RUN groupadd --gid 65432 xrootd && \
    useradd --gid xrootd --uid 65432 xrootd

# Repositories
COPY *.repo /etc/yum.repos.d/

# Install versionlock, and configure versionlocks
RUN dnf -y install python3-dnf-plugin-versionlock && \
    dnf -y versionlock add ceph-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   ceph-base-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   ceph-common-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   ceph-mds-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   ceph-mgr-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   ceph-mon-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   ceph-osd-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   ceph-selinux-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   libcephfs2-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   librados2-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   libradosstriper1-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   librbd1-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   librgw2-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python-ceph-argparse-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python-cephfs-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python-rados-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python-rbd-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python-rgw-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python3-ceph-argparse-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python3-cephfs-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python3-rados-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python3-rbd-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   python3-rgw-${CEPH_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-${XROOTD_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-client-${XROOTD_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-client-libs-${XROOTD_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-libs-${XROOTD_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-selinux-${XROOTD_VERSION}.${DISTRO}.noarch \
                   xrootd-server-${XROOTD_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-server-libs-${XROOTD_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-ceph-buffered-${XRDCEPH_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-voms-${XROOTD_VERSION}.${DISTRO}.${ARCH} \
                   xrootd-scitokens-${XROOTD_VERSION}.${DISTRO}.${ARCH} && \
    # For debugging purposes, show the versionlock list
    dnf -y versionlock list

# Install CEPH
RUN dnf -y install ceph \
                   ceph-common && \
                    # Clean up cache to keep layer size small
                    dnf clean all && \
                    rm -rf /var/cache/dnf

# Install XROOTD
RUN dnf -y install xrootd-ceph-buffered \
                   xrootd-client \
                   xrootd-client-libs \
                   xrootd-libs \
                   xrootd-server \
                   xrootd-server-libs \
                   xrootd-voms \
                   xrootd-scitokens \
                   jemalloc && \
                   # Clean up cache to keep layer size small
                   dnf clean all && \
                   rm -rf /var/cache/dnf

# For N2N mapping
RUN dnf -y install http://repos.gridpp.rl.ac.uk/yum/xrootd-cmstfc/${DISTRO}/xrootd-cmstfc-1.5.2-6.osgroup.${DISTRO}.${ARCH}.rpm

# Required for health-check scripts
RUN dnf -y install openssl && \
                   # Clean up cache to keep layer size small
                   dnf clean all && \
                   rm -rf /var/cache/dnf

# Python3 required for cephsum script
RUN dnf -y install python3 \
                   python3-rados && \
                   # Clean up cache to keep layer size small
                   dnf clean all && \
                   rm -rf /var/cache/dnf

# Install netcat for service healthcheck
RUN dnf -y install netcat && \
                   # Clean up cache to keep layer size small
                   dnf clean all && \
                   rm -rf /var/cache/dnf

# Update OS packages & tidy up
RUN dnf -y update && \
                   dnf clean all && \
                   rm -rf /var/cache/dnf

# Bake healthcheck script
COPY xrootd-healthcheck.sh .
HEALTHCHECK --interval=180s --timeout=10s --retries=2 \
    CMD bash xrootd-healthcheck.sh

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
