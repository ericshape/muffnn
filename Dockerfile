FROM ubuntu:14.04
MAINTAINER opensource@civisanalytics.com

# Ensure UTF-8 locale.
RUN locale-gen en_US.UTF-8

# Set environment variables for UTF-8, conda, and shell environments
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    LD_LIBRARY_PATH=/opt/conda/lib:$LD_LIBRARY_PATH \
    CONDARC=/opt/conda/.condarc \
    BASH_ENV=/etc/profile \
    PATH=/opt/conda/envs/muffnn/bin:/opt/conda/bin:$PATH

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y \
        git \
        wget \
        ca-certificates \
        curl \
        libpq-dev


RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    /opt/conda/bin/conda install --yes conda

COPY . /src/muffnn
RUN conda env create -f /src/muffnn/environment.yml -q
RUN conda install flake8 pytest pip nose -n muffnn && \
    pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.10.0rc0-cp35-cp35m-linux_x86_64.whl
RUN cd /src/muffnn && \
    pip install .
