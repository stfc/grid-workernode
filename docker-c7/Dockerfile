FROM centos:7

# If installing multiple packages yum will return success if at least one package installs.
# We don't want this, so we provide a wrapper to fail if *any* of the packages fail to install.
RUN echo -e '#!/bin/bash\nfor p in "$@"; do\nyum -y install "$p" || exit 1; done' > /usr/local/sbin/yummy && \
    chmod u+x /usr/local/sbin/yummy && \
    cat /usr/local/sbin/yummy

RUN yummy yum-priorities yum-utils

RUN yummy zip curl

# Create all possible pool accounts
RUN curl -s https://raw.githubusercontent.com/stfc/grid-workernode/master/resources/pool_accounts/create.sh | bash -

# CVMFS (for SAM tests only - SAM tests will fail without client; install before adding other repos to ensure we have the latest version)
RUN yummy https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://ecsft.cern.ch/dist/cvmfs/cvmfs-config-egi/cvmfs-config-egi-2.0-1.el7.centos.noarch.rpm && \
    yummy cvmfs

# EPEL
RUN yummy https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Basic dependencies
RUN yummy freetype expat gcc glibc-headers compat-openldap time man unzip quota attr tcsh

# Install Python3
RUN yummy python3

# Install HEP_OSlibs
RUN yummy http://linuxsoft.cern.ch/wlcg/centos7/x86_64/HEP_OSlibs-7.3.1-2.el7.cern.x86_64.rpm

# Machine job features
RUN yummy http://quattor.web.lal.in2p3.fr/packages/machine-job-features/sl6/noarch/mjf-htcondor-00.19-1.noarch.rpm

# Boost (need to ensure gfal CLI from CVMFS will work for some VOs)
RUN yummy boost-date-time boost-filesystem boost-graph boost-iostreams boost-program-options \
                   boost-python boost-regex boost-serialization boost-signals boost-system boost-test \
                   boost-thread boost-wave

# Apptainer
RUN yummy apptainer

# Disable overlay and loop device management in apptainer
RUN sed -i '/enable overlay/c\enable overlay = no' /etc/apptainer/apptainer.conf && \
    sed -i '/enable underlay/c\enable underlay = yes' /etc/apptainer/apptainer.conf && \
    sed -i '/max loop devices/c\max loop devices = 0' /etc/apptainer/apptainer.conf

# Deny setuid in Apptainer
RUN sed -i '/allow setuid/c\allow setuid = no' /etc/apptainer/apptainer.conf

# Update & cleanup
RUN yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum
