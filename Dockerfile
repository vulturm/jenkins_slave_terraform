#
# Project Name:: en_infra_aws
# File:: jenkins-slave-terraform/Dockerfile 
#
# Copyright (C) 2017 - Present
# Author: 'Mihai Vultur <mihai.vultur@endava.com>'
#
# All rights reserved
#
# Description:
#   Dockerfile used to create a docker image for 
#   jenkins slave that will execute the CI plan.

FROM openjdk:8u121-jdk-alpine
MAINTAINER Mihai Vultur <mihai.vultur@endava.com>

ENV JENKINS_USER=jenkins
ENV JENKINS_GROUP=jenkinsgroup
ENV DOCKER_HOST=tcp://10.9.8.120:4243
ENV TERRAFORM_DIR=/opt/terraform
ENV TERRAFORM_RELEASE=0.9.2
ENV SSH_PORT=22

RUN apk update && \
    apk add bash git openssh openssl wget unzip && \
    rm /var/cache/apk/*

RUN sed -i '/UsePrivilegeSeparation/ s/.*/UsePrivilegeSeparation sandbox/; /UseDNS/ s/.*/UseDNS no/; /PubkeyAuthentication/ s/.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo -e "AuthenticationMethods publickey\n" >> /etc/ssh/sshd_config && \
    #Disable strict host checking for ssh. Required for git.
    echo -e "Host *\n   StrictHostKeyChecking no\n   UserKnownHostsFile=/dev/null\n" >> /etc/ssh/ssh_config && \
    ssh-keygen -b 4096 -f /etc/ssh/ssh_host_rsa_key -t rsa -N "" ; \
    ssh-keygen -b 1024 -f /etc/ssh/ssh_host_dsa_key -t dsa -N "" ; \
    ssh-keygen -b 521 -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N "" ; \
    ssh-keygen -b 4096 -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N "" ; \
    chmod 600 /etc/ssh/ssh_host_*_key

RUN addgroup ${JENKINS_GROUP} && \
    adduser -D -G ${JENKINS_GROUP} -s /bin/bash ${JENKINS_USER} && \
    echo "${JENKINS_USER}:$(openssl rand -base64 32)" | chpasswd && \
    apk del openssl && \
    mkdir -p /home/${JENKINS_USER}/.ssh

RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5HYFmuHEWO8gK9GyA8p+u5yaK+xli53cRxV45N2Xxu8ZZ0TeZj3csoZzM+RsYFUTrdMwm3oFodXWuTaCEyBQhhsaRcM40SFshWm+vDmuNL82IREcHoDm/u9pj2eeTpROqdc2veY8X7w92DVzkgDxf8v7N4OaDwscHa4FpXALgefvltwNIC/M2/XYt6MdEPY/pqyWWrPChAl1m2gsdw4xmXLaH+dx103abpUcfBNnl3kFz1iv4BtqazCvw/Ib8nMWnzZGmMbAsDzWm6Ut3jcngWJ5VoLRcd6R9U72fwTkP+qjBpVqZgl1Tw4SMo8W7k8G/zRW4WL0B7YewSglAuDgv jenkins@3e0ce98a3d30' >> /home/${JENKINS_USER}/.ssh/authorized_keys
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQR/UxNXnD6gSxhJwejZE0YjBYPHtSRQJp2fU0JjOSTHye6apdQme/XPGl8atAng6fyzlZcEaZFMDq7cNFZhrZzgCwtCaRRVdZh+wwJmTa0Qzi/sWK73+nGYnePfN1cFZdY9sLi9UnBgVmB5X5kgnCx4SIGZqUcze+fGW4LaGMVfcwZUo51TP8JfjRtfwAhXl2kIkTR1iY4pJ+ryTzdD5iLSwen5RbJbHsQ1GVpCp3nuUQn7z8Bsqt/BJClKM7HcOV1IbzPKIs49Z2ZP/+n03Km4VKaVkqPU8m29PBk8pYK6QP18SNTvgRFugqGSJqNDQt0H8FM1uGc8tqAuttlbxN xanto@fedora.test.lo' | tee -a /home/${JENKINS_USER}/.ssh/authorized_keys /home/${JENKINS_USER}/.ssh/id_rsa.pub


RUN chown -R ${JENKINS_USER}:${JENKINS_GROUP} /home/${JENKINS_USER} && \
    chmod +x /home/${JENKINS_USER} && \
    chmod 600 /home/${JENKINS_USER}/.ssh/authorized_keys

#-- provision terraform
RUN mkdir -p $TERRAFORM_DIR && \
    wget --no-check-certificate https://releases.hashicorp.com/terraform/${TERRAFORM_RELEASE}/terraform_${TERRAFORM_RELEASE}_linux_amd64.zip -O /opt/terraform_${TERRAFORM_RELEASE}_linux_amd64.zip && \
    unzip -q -o /opt/terraform_${TERRAFORM_RELEASE}_linux_amd64.zip -d ${TERRAFORM_DIR} && \
    rm -rf /opt/terraform_${TERRAFORM_RELEASE}_linux_amd64.zip && \
    ln -sf ${TERRAFORM_DIR}/terraform /usr/bin/terraform

EXPOSE $SSH_PORT

CMD ["/usr/sbin/sshd", "-D"]
#ENTRYPOINT ["ping", "8.8.8.8"]
