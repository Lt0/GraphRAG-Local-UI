FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl gpg git

# install conda
RUN curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
RUN install -o root -g root -m 644 conda.gpg /usr/share/keyrings/conda-archive-keyring.gpg
RUN gpg --keyring /usr/share/keyrings/conda-archive-keyring.gpg --no-default-keyring --fingerprint 34161F5BF5EB1D4BFBBB8F0A8AEB4F8B29D82806
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/conda-archive-keyring.gpg] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list
RUN apt-get update && apt-get install conda
ENV PATH=$PATH:/opt/conda/bin

# create graphrag-local venv
RUN conda init bash \
    && . ~/.bashrc \
    && conda create -n graphrag-local -y \
    && conda activate graphrag-local

# install graphrag-local-ui
COPY . /root/graphrag-local-ui
WORKDIR /root/graphrag-local-ui
RUN pip install -e ./graphrag
RUN pip install -r requirements.txt
