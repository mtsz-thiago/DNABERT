
FROM nvidia/cuda:10.2-cudnn7-runtime-centos8

WORKDIR /wrk

RUN yum -y update && \
    yum -y install python3-devel python3-pip && \
    yum -y group install "Development Tools"

COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
   && rm -rf /tmp/pip-tmp

RUN python3 -m pip install --editable .