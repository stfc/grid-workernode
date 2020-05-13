FROM centos:8

RUN dnf -y install zip curl

# Create all possible pool accounts
RUN curl -s https://raw.githubusercontent.com/stfc/grid-workernode/master/resources/pool_accounts/create.sh | bash -

# CVMFS (for SUM tests only; install before adding other repos to ensure we have the latest version)
RUN dnf -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://download.opensuse.org/repositories/home:/cvmfs:/contrib-egi/CentOS_7/noarch/cvmfs-config-egi-2.4-1.10.obs.el7.noarch.rpm
#    dnf -y install cvmfs-2.5.2-1.el8.x86_64

# EPEL
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Basic dependencies
RUN dnf -y install freetype expat gcc glibc-headers time man unzip quota attr tcsh

# Install HEP_OSlibs
# Broken python dependencies on CentOS 8
# RUN dnf -y install http://linuxsoft.cern.ch/wlcg/centos7/x86_64/HEP_OSlibs-7.2.10-1.el7.cern.x86_64.rpm

# Machine job features
# Broken python dependencies on CentOS 8
# RUN dnf -y install http://quattor.web.lal.in2p3.fr/packages/machine-job-features/sl6/noarch/mjf-htcondor-00.19-1.noarch.rpm

# Boost (need to ensure gfal CLI from CVMFS will work for some VOs)
RUN dnf -y install boost-date-time boost-filesystem boost-graph boost-iostreams boost-program-options \
                   boost-regex boost-serialization boost-signals boost-system boost-test \
                   boost-thread boost-wave

# Singularity
RUN dnf -y install singularity

# Disable overlay and loop device management in singularity
RUN sed -i '/enable overlay/c\enable overlay = no' /etc/singularity/singularity.conf && \
    sed -i '/enable underlay/c\enable underlay = yes' /etc/singularity/singularity.conf && \
    sed -i '/max loop devices/c\max loop devices = 0' /etc/singularity/singularity.conf

# Update & cleanup
RUN dnf -y update && \
    dnf clean all && \
    rm -rf /var/cache/dnf
