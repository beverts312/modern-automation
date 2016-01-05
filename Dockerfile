FROM python

RUN pip install ansible -y

ENV WORKDIR=/apps/ansible

ADD /src /${WORKDIR}

ENTRYPOINT ${WORKDIR}

RUN chmod +x setcreds.sh

ENV PLAYBOOK=aws_create_swarm_cluster.yml
ENV CLUSTER_SIZE=3
ENV CLUSTER_NAME=docker
ENV EXTRA_VARS="cf_stack_name=${CLUSTER_NAME} cf_cluster_size=${CLUSTER_SIZE}"

CMD setcreds.sh  &&\
    ansible-playbook ${PLAYBOOK} --extra-vars ${EXTRA_VARS}