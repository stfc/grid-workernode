FROM rockylinux:8

# Add labels
LABEL org.opencontainers.image.source=https://github.com/stfc/grid-workernode
LABEL org.opencontainers.image.authors=gstsm@stfc.atlassian.net
LABEL org.opencontainers.image.description="A specialised container image optimised for high-performance batch job execution in RAL's computing environment. \
It includes essential software, libraries, and dependencies, ensuring efficient, and scalable job processing, benefiting researchers and organisations."

# Basic dependencies
RUN dnf -y install \
    zip \
    curl \
    freetype \
    expat \
    gcc \
    glibc-headers \
    time \
    man \
    unzip \
    quota \
    attr \
    tcsh \
    numactl \
    bc \
    wget && \
    # Clean up cache to keep layer size small
    dnf clean all && \
    rm -rf /var/cache/dnf

# CVMFS (for SUM tests only; install before adding other repos to ensure we have the latest version)
RUN dnf -y install https://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-release-latest.noarch.rpm \
                   https://download.opensuse.org/repositories/home:/cvmfs:/contrib-egi/AlmaLinux_8/noarch/cvmfs-config-egi-2.7-1.8.obs.el8.noarch.rpm && \
    # Install CVMFS
    dnf -y install cvmfs && \
    # Clean up cache to keep layer size small
    dnf clean all && \
    rm -rf /var/cache/dnf

# Install EPEL repository
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Install HEP_OSlibs
RUN dnf -y install https://linuxsoft.cern.ch/wlcg/centos8/x86_64/wlcg-repo-1.0.0-1.el8.noarch.rpm && \
    dnf -y install --enablerepo=devel HEP_OSlibs && \
    # Clean up cache to keep layer size small
    dnf clean all && \
    rm -rf /var/cache/dnf

# Boost (need to ensure gfal CLI from CVMFS will work for some VOs)
RUN dnf -y install boost-date-time boost-filesystem boost-graph boost-iostreams boost-program-options \
                   boost-regex boost-serialization boost-signals boost-system boost-test \
                   boost-thread boost-wave && \
    # Clean up cache to keep layer size small
    dnf clean all && \
    rm -rf /var/cache/dnf

# Install Apptainer
RUN dnf -y install apptainer && \
    # Clean up cache to keep layer size small
    dnf clean all && \
    rm -rf /var/cache/dnf

# Update OS packages & tidy up
RUN dnf -y update && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Create all possible pool accounts
RUN curl -s https://raw.githubusercontent.com/stfc/grid-workernode/master/resources/pool_accounts/create.sh | bash -
