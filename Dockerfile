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
RUN chmod +x ${WORKDIR}/setcreds.sh

ENV PLAYBOOK=aws_create_swarm_cluster.yml
ENV CLUSTER_SIZE=3
ENV CLUSTER_NAME=docker
ENV EXTRA_VARS="cf_stack_name=${CLUSTER_NAME} cf_cluster_size=${CLUSTER_SIZE}"

CMD bash -x setcreds.sh  &&\
    ansible-playbook ${PLAYBOOK} --extra-vars cf_stack_name=${CLUSTER_NAME} cf_cluster_size=${CLUSTER_SIZE}

#ENTRYPOINT ${WORKDIR}/run.sh