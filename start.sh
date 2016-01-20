echo "aws_access_key:${AWS_ACCESS}" >> ${WORKDIR}/group_vars/all/credentials.yml
echo "aws_secret_key:${AWS_SECRET}" >> ${WORKDIR}/group_vars/all/credentials.yml
echo "aws_keypair:${AWS_KEYPAIR}" >> ${WORKDIR}/group_vars/all/credentials.yml
ansible-playbook $PLAYBOOK --extra-vars $EXTRA_VARS