FROM centos:6

# If installing multiple packages yum will return success if at least one package installs.
# We don't want this, so we provide a wrapper to fail if *any* of the packages fail to install.
RUN echo -e '#!/bin/bash\nfor p in "$@"; do\nyum -y install "$p" || exit 1; done' > /usr/local/sbin/yummy && \
    chmod u+x /usr/local/sbin/yummy && \
    cat /usr/local/sbin/yummy

RUN yummy yum-priorities yum-utils

RUN yummy zip curl

# Create all possible pool accounts
RUN curl -s https://raw.githubusercontent.com/stfc/grid-workernode/master/resources/pool_accounts/create.sh | bash -

# CVMFS (for SUM tests only; install before adding other repos to ensure we have the latest version)
# Install cvmfs-x509-helper for access to secure CVMFS repositories
RUN yummy https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://ecsft.cern.ch/dist/cvmfs/cvmfs-config-egi/cvmfs-config-egi-2.0-1.el6.noarch.rpm  && \
    yummy cvmfs-2.5.2-1.el6.x86_64 && \
    yummy https://ecsft.cern.ch/dist/cvmfs/cvmfs-x509-helper/cvmfs-x509-helper-1.0-1.el6.x86_64.rpm

# EPEL
RUN yummy https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

# Unified Middleware distribution
RUN yummy http://repository.egi.eu/sw/production/umd/4/sl6/x86_64/updates/umd-release-4.1.3-1.el6.noarch.rpm

# Basic dependencies
RUN yummy freetype expat gcc glibc-headers compat-expat1 compat-openldap time man unzip quota attr tcsh

# Install HEP_OSlibs
RUN yummy http://linuxsoft.cern.ch/wlcg/sl6/x86_64/HEP_OSlibs_SL6-1.1.9-2.el6.x86_64.rpm

# Install glexec, lcmaps & lcas
RUN yummy glexec mkgltempdir \
                   lcmaps lcmaps-plugins-verify-proxy lcmaps-plugins-basic lcmaps-plugins-voms lcmaps-plugins-c-pep \
                   lcas lcas-plugins-basic lcas-plugins-voms

# Machine job features
RUN yummy http://quattor.web.lal.in2p3.fr/packages/machine-job-features/sl6/noarch/mjf-htcondor-00.19-1.noarch.rpm

# Boost (need to ensure gfal CLI from CVMFS will work for some VOs)
RUN yummy boost-date-time boost-filesystem boost-graph boost-iostreams boost-program-options \
                   boost-python boost-regex boost-serialization boost-signals boost-system boost-test \
                   boost-thread boost-wave

# Singularity
RUN yummy singularity singularity-runtime

# Disable overlay and loop device management in singularity
RUN sed -i '/enable overlay/c\enable overlay = no' /etc/singularity/singularity.conf && \
    sed -i '/enable underlay/c\enable underlay = yes' /etc/singularity/singularity.conf && \
    sed -i '/max loop devices/c\max loop devices = 0' /etc/singularity/singularity.conf

# Update & cleanup
RUN yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum

# glexec
RUN mkdir -p /opt/glite/sbin && ln -s /usr/sbin/glexec /opt/glite/sbin/glexec
RUN mkdir -p /var/log/glexec && chown root:glexec /var/log/glexec

# Required for jobs created by glite-WMS submitted to an ARC CE
RUN touch /usr/etc/globus-user-env.sh
