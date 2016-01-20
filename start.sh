#!/bin/bash
perl -p -e 's/##([^#]+)##/defined $ENV{$1} ? $ENV{$1} : die "$1 is not set in $ARGV"/eg;' ${WORKDIR}\group_vars\all\common.yml > ${WORKDIR}\group_vars\all\common.yml
cat ${WORKDIR}\group_vars\all\common.yml
#ansible-playbook $PLAYBOOK 