FROM centos:centos7

RUN yum upgrade -y
RUN yum install -y epel-release
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm \
                   http://awel.domblogger.net/7/media/x86_64/awel-media-release-7-5.noarch.rpm

RUN rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO && \
    curl -s https://mirror.go-repo.io/centos/go-repo.repo > /etc/yum.repos.d/go-repo.repo && \
    yum install -y golang


ENV PATH=/opt/env/bin:/usr/bin:/bin:/usr/sbin:/sbin

RUN yum groupinstall -y "Development Tools"

RUN yum install -y \
             bzip2-devel \
             ffmpeg \
             freetype-devel \
             gmp-devel \
             lcms2-devel \
             libattr-devel \
             libcurl-devel \
             libjpeg-turbo-devel \
             libmount-devel \
             libmpc-devel \
             libpqxx-devel \
             libsemanage-devel \
             libtelnet-devel \
             libtiff-devel \
             libuuid-devel \
             libwebp-devel \
             llvm-devel \
             mariadb-devel \
             mpfr-devel \
             mpg123-devel \
             msgpack-devel \
             openjpeg-devel \
             openjpeg2-devel \
             pnglite-devel \
             protobuf-devel \
             rrdtool-devel \
             sip-devel \
             sox-devel \
             systemd-devel \
             tcl-devel \
             tk-devel \
             turbojpeg-devel \
             zeromq-devel \
             zlib-devel

RUN yum -y install texlive texlive-*.noarch

RUN yum install -y python36u python36u-pip python36u-devel python-pip python-devel gcc make git
RUN pip3.6 install virtualenv

RUN useradd -ms /bin/bash -d /data -u 1000 user && mkdir -p /data && chown 1000:1000 /data

RUN pip2.7 install -U 'ipython[notebook]<6' Cython
RUN pip3.6 install -U 'tornado==4.5.3' 'ipython[notebook]' Cython

# Installing Gophernotes
RUN mkdir -p /var/lib/gohome/{bin,pkg,src} && \
    export GOPATH=/var/lib/gohome && \
    export PATH="$PATH:/var/lib/gohome/bin" && \
    go get golang.org/x/tools/cmd/goimports && \
    go get github.com/gophergala2016/gophernotes && \
    mkdir -p /usr/share/jupyter/kernels/gophernotes && \
    cp -a /var/lib/gohome/src/github.com/gophergala2016/gophernotes/kernel/* /usr/share/jupyter/kernels/gophernotes


COPY packages-27.txt /tmp/packages-27.txt
COPY packages-36.txt /tmp/packages-36.txt

RUN pip2 install -r /tmp/packages-27.txt
RUN pip3.6 install -r /tmp/packages-36.txt

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

USER user

ENV PATH=$PATH:/var/lib/gohome/bin:/data/go/bin
ENV GOPATH=/data/go

WORKDIR /data

VOLUME [ "/data" ]
EXPOSE 8000

CMD /usr/local/bin/entrypoint.sh
