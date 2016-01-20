#!/bin/bash
perl -p -e 's/##([^#]+)##/defined $ENV{$1} ? $ENV{$1} : die "$1 is not set in $ARGV"/eg;' ${WORKDIR}\group_vars\all\common.yml > ${WORKDIR}\group_vars\all\common.yml
perl -p -e 's/##([^#]+)##/defined $ENV{$1} ? $ENV{$1} : die "$1 is not set in $ARGV"/eg;' ${WORKDIR}\group_vars\all\credentials.yml > ${WORKDIR}\group_vars\all\credentials.yml
cat ${WORKDIR}\group_vars\all\common.yml
cat ${WORKDIR}\group_vars\all\credentials.yml
#ansible-playbook $PLAYBOOK 