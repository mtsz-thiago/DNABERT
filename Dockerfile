# --------------------------------------------------------------------------------------------------
FROM python:3.6 AS PIP_INSTALL

WORKDIR /tmp

RUN mkdir /transofrmers

COPY . .

RUN pip3 install --target /transofrmers .

# --------------------------------------------------------------------------------------------------
FROM nvidia/cuda:10.2-cudnn7-runtime-centos8 AS DEV

WORKDIR /wrk

COPY --from=PIP_INSTALL /transofrmers /usr/local/lib/python3.6/site-packages/

RUN yum -y update && \
    yum -y install python3-devel python3-pip && \
    yum -y group install "Development Tools"

COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install --user -r /tmp/pip-tmp/requirements.txt \
   && rm -rf /tmp/pip-tmp

# --------------------------------------------------------------------------------------------------
FROM nvidia/cuda:10.2-cudnn7-runtime-centos8 AS DNABERT

WORKDIR /app

COPY --from=DEV /usr/local/lib/python3.6/site-packages/ /usr/local/lib/python3.6/site-packages

RUN yum -y update && \
    yum -y install python3

COPY --from=PIP_INSTALL /tmp/examples/*.py ./
COPY --from=PIP_INSTALL /tmp/examples/scripts/ .
COPY --from=PIP_INSTALL /tmp/motif/ ./motif/
COPY --from=PIP_INSTALL /tmp/SNP/ ./SNP/

ENTRYPOINT ["python3"]