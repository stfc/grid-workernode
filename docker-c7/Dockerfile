FROM centos:7

# If installing multiple packages yum will return success if at least one package installs.
# We don't want this, so we provide a wrapper to fail if *any* of the packages fail to install.
RUN echo -e '#!/bin/bash\nfor p in "$@"; do\nyum -y install "$p" || exit 1; done' > /usr/local/sbin/yummy && \
    chmod u+x /usr/local/sbin/yummy && \
    cat /usr/local/sbin/yummy

RUN yummy yum-priorities

RUN yummy zip

# CVMFS (for SUM tests only; install before adding other repos to ensure we have the latest version)
RUN yummy https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://ecsft.cern.ch/dist/cvmfs/cvmfs-config-egi/cvmfs-config-egi-2.0-1.el7.centos.noarch.rpm && \
    yummy cvmfs-2.5.2-1.el7.x86_64

# EPEL
RUN yummy https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Basic dependencies
RUN yummy freetype expat gcc glibc-headers compat-expat1 compat-openldap time man unzip quota attr tcsh

# Install HEP_OSlibs
RUN yummy http://linuxsoft.cern.ch/wlcg/centos7/x86_64/HEP_OSlibs-7.2.6-1.el7.cern.x86_64.rpm

# Machine job features
RUN yummy http://quattor.web.lal.in2p3.fr/packages/machine-job-features/sl6/noarch/mjf-htcondor-00.19-1.noarch.rpm

# Boost (need to ensure gfal CLI from CVMFS will work for some VOs)
RUN yummy boost-date-time boost-filesystem boost-graph boost-iostreams boost-program-options \
                   boost-python boost-regex boost-serialization boost-signals boost-system boost-test \
                   boost-thread boost-wave

# Singularity
RUN yummy singularity-2.6.1-1.1.el7.x86_64 \
                   singularity-runtime-2.6.1-1.1.el7.x86_64

# Disable overlay and loop device management in singularity
RUN sed -i '/enable overlay/c\enable overlay = no' /etc/singularity/singularity.conf

RUN sed -i '/max loop devices/c\max loop devices = 0' /etc/singularity/singularity.conf

# Update & cleanup
RUN yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum
