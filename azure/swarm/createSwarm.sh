#!/bin/bash

LOCATION="centralus"
WORKER_COUNT=2
ANSIBLE_DIR=../../ansible
VSTS="true"

showUsage() {
  cat <<EOF

Usage: $0
          -n <resource-group>
          -p <public-key>
          -k <key-path>
          [ -v <vsts> (defaults to $VSTS)]
          [ -c <worker-count> (defaults to $WORKER_COUNT) ]
          [ -l <location> (defaults to $LOCATION) ]
          [ -d (debug) ]
          [ -f (invoke ansible playbook) ]

EOF
}

unset DEPLOYMENT DEBUG_ARGS PUBLIC_KEY SERVICE_KEY_LOCATION SERVICE_ACCOUNT FULL_DEPLOY NAME KEY_PATH

while getopts "n:p:c:d:k:f:v:P" opt ; do
  case $opt in
    n) NAME=$OPTARG;;
    c) WORKER_COUNT=$OPTARG;;
    p) PUBLIC_KEY=$OPTARG;;
    v) VSTS=$OPTARG;;
    k) KEY_PATH=$OPTARG;;
    d) DEBUG_ARGS="-d";;
    f) FULL_DEPLOY="yes";;
    ?) showUsage; exit 1;;
  esac
done

# Turn on full script debugging if the user has passed the debug flag.
if [[ -n "$DEBUG_ARGS" ]] ; then
  set -x
fi

if [[ -z "$NAME" || \
      -z "$PUBLIC_KEY" ]] ; then
  showUsage
  exit 1
fi

echo "Setting CLI to ARM mode..."
azure config mode arm
if [[ $? -ne 0 ]] ; then
  echo "Failed to set ARM mode, see details above"
  exit 1
fi

echo "Creating resource group..."
azure group create --name $NAME --location $LOCATION           
if [[ $? -ne 0 ]] ; then
  echo "Failed to create resource group, see details above"
  exit 1
fi

echo "Starting deployment..."
echo "TODO: Use passed WORKER_COUNT & PUBLIC_KEY (using params.json for now)"
azure group deployment create --name $NAME --resource-group $NAME --template-file template.json --parameters-file params.json
if [[ $? -ne 0 ]] ; then
  echo "ARM deploy failed, see details above"
  exit 1
fi

echo "Gathering resource information..."
MASTER_IPS=($(azure network public-ip list $NAME | grep swarm-master | awk ' { print $8 }'))
WORKER_IPS=($(azure network public-ip list $NAME | grep swarm-node | awk ' { print $8 }'))

echo "Creating ansible hosts file..."
cd $ANSIBLE_DIR
echo "[swarm_master]"                                           >  hosts
echo "${MASTER_IPS[0]} ansible_ssh_user=\"azureuser\""          >> hosts
echo "[other_masters]"                                          >> hosts
echo "${MASTER_IPS[1]} ansible_ssh_user=\"azureuser\""          >> hosts
echo "[swarm_nodes]"                                            >> hosts
for i in "${!WORKER_IPS[@]}"
do
    echo "$i ${WORKER_IPS[$i]}"
    echo "${WORKER_IPS[$i]} ansible_ssh_user=\"azureuser\""     >> hosts
done
echo "[launched]"                                               >> hosts
for i in "${!MASTER_IPS[@]}"
do
    echo "${MASTER_IPS[$i]} ansible_ssh_user=\"azureuser\""    >> hosts
done
for i in "${!WORKER_IPS[@]}"
do
    echo "${WORKER_IPS[$i]} ansible_ssh_user=\"azureuser\""     >> hosts
done

if [[ -n "$FULL_DEPLOY" ]] ; then
  echo "Waiting 10 minutes for cloud init to finish (FIX THIS)"
  sleep 13m
  echo "Configuring Swarm"
  ansible-playbook create_swarm_cluster.yml --private-key=$KEY_PATH -e "enable_remote_swarm=yes"
  if [[ $? -ne 0 ]] ; then
    echo "Ansible playbook failed, see details above"
    exit 1
  fi
else
  echo "Run \"ansible-playbook create_swarm_cluster.yml --private-key=/keys/gce.pem -e \"enable_remote_swarm=yes\" from $(pwd) to configure your swarm cluster"
fi

if [[ "$VSTS" -eq "true" ]] ; then
  echo "Preping workspace for adding new docker endpoint"
  echo "##vso[task.setvariable variable=docker_url;]tcp://${MASTER_IPS[0]}:2375"
  echo "Move Certs"
  cd $(dirname $0)
  mkdir certs
  cp ${ANSIBLE_DIR}/certs/${MASTER_IPS[0]}KEY.pem $(dirname $0)/certs/key.pem
  cp ${ANSIBLE_DIR}/${MASTER_IPS[0]}CRT.pem $(dirname $0)/certs/cert.pem
  cp ${ANSIBLE_DIR}/certs/ca.pem $(dirname $0)/certs/ca.pem
fi