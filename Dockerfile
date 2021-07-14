FROM python:3.6 AS PIP_INSTALL

WORKDIR /tmp

RUN mkdir /transofrmers

COPY . .

RUN pip3 install --target /transofrmers .

FROM nvidia/cuda:10.2-cudnn7-runtime-centos8 AS DEV

COPY --from=PIP_INSTALL /transofrmers /usr/local/lib/python3.6/site-packages/

WORKDIR /wrk

RUN yum -y update && \
    yum -y install python3-devel python3-pip && \
    yum -y group install "Development Tools"

COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
   && rm -rf /tmp/pip-tmp