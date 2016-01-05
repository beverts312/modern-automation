FROM python

RUN pip install ansible

ENV WORKDIR=/apps/ansible

ADD /src /${WORKDIR}

ENTRYPOINT ${WORKDIR}

RUN chmod +x ${WORKDIR}/setcreds.sh

ENV PLAYBOOK=aws_create_swarm_cluster.yml
ENV CLUSTER_SIZE=3
ENV CLUSTER_NAME=docker
ENV EXTRA_VARS="cf_stack_name=${CLUSTER_NAME} cf_cluster_size=${CLUSTER_SIZE}"

CMD cd ${WORKDIR} &&\
    bash -x setcreds.sh  &&\
    ansible-playbook ${PLAYBOOK} --extra-vars ${EXTRA_VARS}