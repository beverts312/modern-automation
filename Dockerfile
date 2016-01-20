FROM ubuntu:14.04

ENV WORKDIR /apps/ansible
WORKDIR ${WORKDIR}

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible &&\
    echo '[local]\nlocalhost\n' > /etc/ansible/hosts

ADD /playbooks ${WORKDIR}
ADD start.sh ${WORKDIR}/start.sh

ENTRYPOINT ["/apps/ansible/start.sh"]