#!/bin/bash
perl -p -e 's/##([^#]+)##/defined $ENV{$1} ? $ENV{$1} : die "$1 is not set in $ARGV"/eg;' ${WORKDIR}/group_vars/all/common.yml.template > ${WORKDIR}/group_vars/all/common.yml
rm ${WORKDIR}/group_vars/all/common.yml.template
cat ${WORKDIR}/group_vars/all/common.yml
#ansible-playbook $PLAYBOOK 