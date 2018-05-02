FROM centos:7

RUN yum -y install yum-priorities

# CVMFS (for SUM tests only; install before adding other repos to ensure we have the latest version)
RUN yum -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://ecsft.cern.ch/dist/cvmfs/cvmfs-config-egi/cvmfs-config-egi-2.0-1.el7.centos.noarch.rpm && \
    yum -y install cvmfs

# EPEL
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Basic dependencies
RUN yum -y install freetype expat gcc glibc-headers compat-expat1 compat-openldap time man unzip quota attr tcsh

# Install HEP_OSlibs
RUN yum -y install http://linuxsoft.cern.ch/wlcg/centos7/x86_64/HEP_OSlibs-7.2.6-1.el7.cern.x86_64.rpm

# Machine job features
RUN yum -y install wget
RUN wget --no-check-certificate https://repo.gridpp.ac.uk/machinejobfeatures/mjf-scripts/00/RPMS/mjf-htcondor-00.14-1.noarch.rpm && \
    yum -y localinstall mjf-htcondor-00.14-1.noarch.rpm && \
    rm -f mjf-htcondor-00.14-1.noarch.rpm

# Boost (need to ensure gfal CLI from CVMFS will work for some VOs)
RUN yum -y install boost-date-time boost-filesystem boost-graph boost-iostreams boost-program-options \
                   boost-python boost-regex boost-serialization boost-signals boost-system boost-test \
                   boost-thread boost-wave

# Singularity
RUN yum -y install http://linuxsoft.cern.ch/wlcg/centos7/x86_64/singularity-2.5.0-1.1.osg34.el7.x86_64.rpm \
                   http://linuxsoft.cern.ch/wlcg/centos7/x86_64/singularity-runtime-2.5.0-1.1.osg34.el7.x86_64.rpm
RUN sed -i '/enable overlay/c\enable overlay = no' /etc/singularity/singularity.conf

# Update & cleanup
RUN yum -y update && \
    yum clean all
