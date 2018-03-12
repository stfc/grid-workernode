FROM centos:6

RUN yum -y install yum-priorities

# CVMFS (for SUM tests only; install before adding other repos to ensure we have the latest version)
RUN yum -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
                   https://ecsft.cern.ch/dist/cvmfs/cvmfs-config-egi/cvmfs-config-egi-2.0-1.el6.noarch.rpm  && \
    yum -y install cvmfs

# Needed for access to secure CVMFS repositories
RUN yum -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-x509-helper/cvmfs-x509-helper-1.0-1.el6.x86_64.rpm

# EPEL
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

# UMD
RUN yum -y install http://repository.egi.eu/sw/production/umd/3/sl6/x86_64/updates/umd-release-3.14.4-1.el6.noarch.rpm

# Basic dependencies
RUN yum -y install freetype expat gcc glibc-headers compat-expat1 compat-openldap time man unzip quota attr

# Install HEP_OSlibs
RUN yum -y install http://linuxsoft.cern.ch/wlcg/sl6/x86_64/HEP_OSlibs_SL6-1.1.4-1.el6.x86_64.rpm

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
RUN yum -y install http://linuxsoft.cern.ch/wlcg/sl6/x86_64/singularity-2.4.2-1.osg34.el6.x86_64.rpm \
                   http://linuxsoft.cern.ch/wlcg/sl6/x86_64/singularity-runtime-2.4.2-1.osg34.el6.x86_64.rpm

# Update & cleanup
RUN yum -y update && \
    yum clean all

# glexec
RUN mkdir -p /opt/glite/sbin && ln -s /usr/sbin/glexec /opt/glite/sbin/glexec
RUN mkdir -p /var/log/glexec && chown root:glexec /var/log/glexec

# Required for jobs created by glite-WMS submitted to an ARC CE
RUN touch /usr/etc/globus-user-env.sh
