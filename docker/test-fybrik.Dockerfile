FROM python:3.10-slim

COPY test/ test/

RUN apt update && apt upgrade -y && \
    apt install curl bash openssl jq unzip gettext-base vim -y

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && ./aws/install

RUN pip install pandas pyarrow==7.0.* pytest