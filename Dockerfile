FROM centos:7

RUN mkdir -p ~/.pip
COPY ./ci/pip.conf ~/.pip/pip.conf
COPY ./ci/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i 's/enabled=.*/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN yum update -y
RUN yum install -y git gcc wget openssl-devel libffi-devel make yum autoconf automake gcc-c++ rpm-build

# python build install
RUN wget --no-check-certificate https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tar.xz 
RUN tar xJvf Python-3.9.5.tar.xz \
    && cd Python-3.9.5 \
    && ./configure \
    && make \
    && make altinstall
RUN ln -s /usr/local/bin/pip3.9 /usr/local/bin/pip \
    && ln -s /usr/local/bin/python3.9 /usr/local/bin/python \
    && ln -s /usr/local/bin/python3.9 /usr/local/bin/python3

RUN git clone -b 0.12 --single-branch https://github.com/NixOS/patchelf.git \
    && cd patchelf \
    && ./bootstrap.sh \
    && ./configure \
    && make && make install

RUN pip install --upgrade cx_Freeze

WORKDIR /code
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# cython import
RUN pip install -U \
    git+https://github.com/marcelotduarte/cx_Freeze.git@main 

COPY setup.py setup.py
COPY build_test build_test
RUN set -ex \
    && python setup.py bdist_rpm
RUN rpm -ivh dist/*.rpm

CMD ["build_test"]
