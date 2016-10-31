#!/bin/bash

LOCATION="centralus"
WORKER_COUNT=2
ANSIBLE_DIR=../../ansible

showUsage() {
  cat <<EOF

Usage: $0
          -n <resource-group>
          -p <public-key>
          -k <key-path>
          [ -c <worker-count> (defaults to $WORKER_COUNT) ]
          [ -l <location> (defaults to $LOCATION) ]
          [ -d (debug) ]
          [ -f (invoke ansible playbook) ]

EOF
}

unset DEPLOYMENT DEBUG_ARGS PUBLIC_KEY SERVICE_KEY_LOCATION SERVICE_ACCOUNT FULL_DEPLOY NAME KEY_PATH

while getopts "n:p:c:d:k:f:P" opt ; do
  case $opt in
    n) NAME=$OPTARG;;
    c) WORKER_COUNT=$OPTARG;;
    p) PUBLIC_KEY=$OPTARG;;
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
NODE_IPS=($(azure network public-ip list $NAME | grep consul-node | awk ' { print $8 }'))

echo "Creating ansible hosts file..."
cd $ANSIBLE_DIR
echo "[consul_master]"                                           >  hosts
echo "${NODE_IPS[0]} ansible_ssh_user=\"azureuser\""          >> hosts
echo "[other_masters]"                                          >> hosts
echo "${MASTER_IPS[1]} ansible_ssh_user=\"azureuser\""          >> hosts
echo "[other_masters]"                                            >> hosts
for i in "${!NODE_IPS[@]}"
do
    if [[ "$i" -ne "0"  ]] ; then
      echo "$i ${NODE_IPS[$i]}"
      echo "${NODE_IPS[$i]} ansible_ssh_user=\"azureuser\""     >> hosts
    fi
done
echo "[launched]"                                               >> hosts
for i in "${!NODE_IPS[@]}"
do
    echo "${NODE_IPS[$i]} ansible_ssh_user=\"azureuser\""     >> hosts
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
  echo "Run \"ansible-playbook create_consul_cluster.yml --private-key=/keys/gce.pem -e \"enable_remote_swarm=yes\" from $(pwd) to configure your swarm cluster"
fi