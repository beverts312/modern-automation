#!/bin/bash
export CLOUDSDK_PYTHON_SITEPACKAGES=1
ZONE=us-central1-f
WORKER_COUNT=2
ANSIBLE_DIR=../../ansible
VSTS="true"

showUsage() {
  cat <<EOF

Usage: $0
          -n <deployment-name>
          -a <ssh-key-path>
          -u <user> (defaults to $GCE_USER)
	        -s <service-account>
          -k <sevice-key-path>
          -p <project>
          [ -v <vsts> (defaults to $VSTS)]
          [ -c <worker-count> (defaults to $WORKER_COUNT) ]
          [ -z <zone> (defaults to $ZONE) ]
          [ -d (debug) ]
	        [ -f (invoke ansible playbook) ]

EOF
}

unset DEPLOYMENT DEBUG_ARGS GCE_USER GCE_PROJECT SERVICE_KEY_LOCATION SERVICE_ACCOUNT FULL_DEPLOY SSH_KEY_PATH

while getopts "a:n:c:u:z:k:s:p:d:f:v:P" opt ; do
  case $opt in
    a) SSH_KEY_PATH=$OPTARG;;
    n) DEPLOYMENT=$OPTARG;;
    c) WORKER_COUNT=$OPTARG;;
    p) GCE_PROJECT=$OPTARG;;
    u) GCE_USER=$OPTARG;;
    z) ZONE=$OPTARG;;
    k) SERVICE_KEY_LOCATION=$OPTARG;;
    s) SERVICE_ACCOUNT=$OPTARG;;
    v) VSTS=$OPTARG;;
    d) DEBUG_ARGS="-d";;
    f) FULL_DEPLOY="yes";;
    ?) showUsage; exit 1;;
  esac
done

# Turn on full script debugging if the user has passed the debug flag.
if [[ -n "$DEBUG_ARGS" ]] ; then
  set -x
fi

if [[ -z "$DEPLOYMENT" || \
      -z "$GCE_PROJECT" || \
      -z "$GCE_USER" || \
      -z "$SSH_KEY_PATH" || \
      -z "$SERVICE_KEY_LOCATION" || \
      -z "$SERVICE_ACCOUNT" ]] ; then
  showUsage
  exit 1
fi

echo "Login to Google Cloud"
CLOUDSDK_PYTHON_SITEPACKAGES=1
gcloud auth activate-service-account $SERVICE_ACCOUNT --key-file $SERVICE_KEY_LOCATION
gcloud config set project $GCE_PROJECT
echo "Setup files"
sed -i "0,/default: us-central1-f/! s/default: us-central1-f/default: $ZONE/" swarm.jinja.schema
sed -i "0,/default: 2/! s/default: 2/default: $WORKER_COUNT/" swarm.jinja.schema

echo "Create Resources"
gcloud deployment-manager deployments create $DEPLOYMENT --config swarm.yaml
if [[ $? -ne 0 ]] ; then
  echo "Failed to set deploy resources, see details above"
  exit 1
fi

echo "Collect Resource Info"
MASTER_VMS=(`gcloud deployment-manager deployments describe $DEPLOYMENT | grep compute.v1.instance | grep master | awk ' { print $1 } '`)
for i in "${!MASTER_VMS[@]}"
do
    MASTER_IPS[$i]=$(gcloud compute instances describe ${MASTER_VMS[$i]} --zone $ZONE | grep natIP | awk ' { print $2 }')
done

WORKER_VMS=(`gcloud deployment-manager deployments describe $DEPLOYMENT | grep compute.v1.instance | grep worker | awk ' { print $1 } '`)
for i in "${!WORKER_VMS[@]}"
do
    WORKER_IPS[$i]=$(gcloud compute instances describe ${WORKER_VMS[$i]} --zone $ZONE | grep natIP | awk ' { print $2 }')
done

cd $ANSIBLE_DIR
echo "Create Ansible host file"
echo "[swarm_master]"                                           >  hosts
echo "${MASTER_IPS[0]} ansible_ssh_user=\"$GCE_USER\""          >> hosts
echo "[other_masters]"                                          >> hosts
echo "${MASTER_IPS[1]} ansible_ssh_user=\"$GCE_USER\""          >> hosts
echo "[swarm_nodes]"                                            >> hosts
for i in "${!WORKER_IPS[@]}"
do
    echo "${WORKER_IPS[$i]} ansible_ssh_user=\"$GCE_USER\""     >> hosts
done
echo "[launched]"                                               >> hosts
for i in "${!MASTER_IPS[@]}"
do
    echo "${MASTER_IPS[$i]} ansible_ssh_user=\"$GCE_USER\""     >> hosts
done
for i in "${!WORKER_IPS[@]}"
do
    echo "${WORKER_IPS[$i]} ansible_ssh_user=\"$GCE_USER\""     >> hosts
done

if [[ -n "$FULL_DEPLOY" ]] ; then
  echo "Wait 2 minutes for cloud init to finish"
  sleep 2m
  echo "Configure Swarm"
  ansible-playbook create_swarm_cluster.yml --private-key=$SSH_KEY_PATH -e "enable_remote_swarm=yes"
  if [[ $? -ne 0 ]] ; then
    echo "Ansible Playbook failed, see details above"
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
  cp ${ANSIBLE_DIR}/certs/${MASTER_IPS[0]}CRT.pem $(dirname $0)/certs/cert.pem
  cp ${ANSIBLE_DIR}/certs/ca.pem $(dirname $0)/certs/ca.pem
fi