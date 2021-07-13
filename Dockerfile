
FROM nvidia/cuda:10.2-cudnn7-runtime-centos8


RUN yum -y update && \
    yum -y install python3-devel python3-pip && \
    yum -y group install "Development Tools"

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
   && rm -rf /tmp/pip-tmp