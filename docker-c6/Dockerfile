FROM centos:6

RUN yum -y install yum-priorities

RUN yum -y install zip

# CVMFS (for SUM tests only; install before adding other repos to ensure we have the latest version)
RUN yum -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://ecsft.cern.ch/dist/cvmfs/cvmfs-config-egi/cvmfs-config-egi-2.0-1.el6.noarch.rpm  && \
    yum -y install cvmfs

# Needed for access to secure CVMFS repositories
RUN yum -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-x509-helper/cvmfs-x509-helper-1.0-1.el6.x86_64.rpm

# EPEL
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

# UMD
RUN yum -y install http://repository.egi.eu/sw/production/umd/4/sl6/x86_64/updates/umd-release-4.1.3-1.el6.noarch.rpm

# Basic dependencies
RUN yum -y install freetype expat gcc glibc-headers compat-expat1 compat-openldap time man unzip quota attr

# Install HEP_OSlibs
RUN yum -y install http://linuxsoft.cern.ch/wlcg/sl6/x86_64/HEP_OSlibs_SL6-1.1.5-1.el6.x86_64.rpm

# Install glexec, lcmaps & lcas
RUN yum -y install glexec mkgltempdir \
                   lcmaps lcmaps-plugins-verify-proxy lcmaps-plugins-basic lcmaps-plugins-voms lcmaps-plugins-c-pep \
                   lcas lcas-plugins-basic lcas-plugins-voms

# Machine job features
RUN yum -y install wget
RUN wget --no-check-certificate https://repo.gridpp.ac.uk/machinejobfeatures/mjf-scripts/00/RPMS/mjf-htcondor-00.14-1.noarch.rpm && \
    yum -y localinstall mjf-htcondor-00.14-1.noarch.rpm && \
    rm -f mjf-htcondor-00.14-1.noarch.rpm

# Boost
RUN yum -y install boost-date-time boost-filesystem boost-graph boost-iostreams boost-program-options \
                   boost-python boost-regex boost-serialization boost-signals boost-system boost-test \
                   boost-thread boost-wave
                   
# Singularity
RUN yum -y install http://mirrors.gridpp.rl.ac.uk/current/epel-6-x86_64/RPMS.base/singularity-2.6.0-1.1.el6.x86_64.rpm \
                   http://mirrors.gridpp.rl.ac.uk/current/epel-6-x86_64/RPMS.base/singularity-runtime-2.6.0-1.1.el6.x86_64.rpm

RUN sed -i '/enable overlay/c\enable overlay = no' /etc/singularity/singularity.conf

RUN sed -i '/max loop devices/c\max loop devices = 0' /etc/singularity/singularity.conf

# Update & cleanup
RUN yum -y update && \
    yum clean all

# glexec
RUN mkdir -p /opt/glite/sbin && ln -s /usr/sbin/glexec /opt/glite/sbin/glexec
RUN mkdir -p /var/log/glexec && chown root:glexec /var/log/glexec

# Required for jobs created by glite-WMS submitted to an ARC CE
RUN touch /usr/etc/globus-user-env.sh
