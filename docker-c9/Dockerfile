FROM rockylinux:9

RUN dnf -y install zip curl-minimal

# Create all possible pool accounts
RUN curl -s https://raw.githubusercontent.com/stfc/grid-workernode/master/resources/pool_accounts/create.sh | bash -

# CVMFS (for SUM tests only; install before adding other repos to ensure we have the latest version)
RUN dnf -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://download.opensuse.org/repositories/home:/cvmfs:/contrib-egi/AlmaLinux_9/noarch/cvmfs-config-egi-2.6-1.7.obs.el9.noarch.rpm

# EPEL
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# Basic dependencies
RUN dnf -y install \
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
  numactl

# Boost (need to ensure gfal CLI from CVMFS will work for some VOs)
RUN dnf -y install boost-date-time boost-filesystem boost-graph boost-iostreams boost-program-options \
                   boost-regex boost-serialization boost-system boost-test \
                   boost-thread boost-wave

# Apptainer
RUN dnf -y install apptainer

# Disable overlay and loop device management in Apptainer
RUN sed -i '/enable overlay/c\enable overlay = no' /etc/apptainer/apptainer.conf && \
    sed -i '/enable underlay/c\enable underlay = yes' /etc/apptainer/apptainer.conf && \
    sed -i '/max loop devices/c\max loop devices = 0' /etc/apptainer/apptainer.conf

# Deny setuid in Apptainer
RUN sed -i '/allow setuid/c\allow setuid = no' /etc/apptainer/apptainer.conf

# Update & cleanup
RUN dnf -y update && \
    dnf clean all && \
    rm -rf /var/cache/dnf
