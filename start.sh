#!/bin/bash
perl -p -e 's/##([^#]+)##/defined $ENV{$1} ? $ENV{$1} : die "$1 is not set in $ARGV"/eg;' ${WORKDIR}\group_vars\all\common.yml.template > ${WORKDIR}\group_vars\all\common.yml
perl -p -e 's/##([^#]+)##/defined $ENV{$1} ? $ENV{$1} : die "$1 is not set in $ARGV"/eg;' ${WORKDIR}\group_vars\all\credentials.yml.template > ${WORKDIR}\group_vars\all\credentials.yml
rm ${WORKDIR}\group_vars\all\common.yml.template
rm ${WORKDIR}\group_vars\all\credentials.yml.template
cat ${WORKDIR}\group_vars\all\common.yml
cat ${WORKDIR}\group_vars\all\credentials.yml
#ansible-playbook $PLAYBOOK 