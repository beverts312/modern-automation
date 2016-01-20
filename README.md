#Dockerized Ansible  
This image makes it easy to run playbooks from anywhere.
Based off [Official Ansible Repo](https://github.com/ansible/ansible-docker-base)  

## How to use  
This image is configured using environmental variables.  
Use the `$PLAYBOOK` variable to choose the playbook to run (i.e `aws_create_swarm_cluster.yml`).  
All the other variables will be playbook specific. The variables exist in `/group_vars/all/common.yml.template` and are surrounded by `##`, these are replaced when the the container starts by some perl in `start.sh`.  

### Example  
1. Clone this repo:  
```
git clone https://beverts.visualstudio.com/DefaultCollection/Main/_git/ansible
```  
2. Navigate to the repo:  
```
cd ansible
```
3. Set the AWS_ACCESS,AWS_SECRET,AWS_KEYPAIR environmental variables on your local machine.  
4. Start with `docker-compose`(the `docker-compose.yml` file in this directory runs a playbook to create a cluster of size 3):  
```
docker-compose up
```  

## Playbooks  
AWS Swarm Playbooks from [Uluc's Github](https://github.com/ulucaydin/ansible-docker-swarm)  

### aws_create_swarm_cluster.ym  
Creates CoreOS Swarm Cluster on AWS.  
These are the required variables:  

|Variable    |Description  |
|------------|-------------|
|AWS_ACCESS  |AWS Key      |
|AWS_SECRET  |AWS Secret   |
|AWS_KEYPAIR |AWS Key Pair*|
|CLUSTER_SIZE|# of Nodes   |
|CLUSTER_NAME|Stack Name   |  
*Must be in us-west-2.
  
### aws_destroy_swarm_cluster.ym  
Destroys CoreOS Swarm Cluster on AWS.  
These are the required variables:  

|Variable    |Description  |
|------------|-------------|
|AWS_ACCESS  |AWS Key      |
|AWS_SECRET  |AWS Secret   |
|CLUSTER_NAME|Stack Name   |  