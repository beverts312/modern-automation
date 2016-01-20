#Dockerized Ansible  
This image makes it easy to run playbooks from anywhere.  


Based off [Official Ansible Repo](https://github.com/ansible/ansible-docker-base), they don't provide an acutal base image but they give you some Dockerfile's to get started.   

## How it works  
The script `start.sh` is what runs when the image starts. 
This first replaces the tokens in `/group_vars/all/common.yml.template` and then starts a playbook.  
Use the `$PLAYBOOK` variable to choose the playbook to run (i.e `aws_create_swarm_cluster.yml`).  
The tokens that are replaced are provided via environmental variables.  

## Playbooks  
AWS Swarm Playbooks from [Uluc's Github](https://github.com/ulucaydin/ansible-docker-swarm)  

### aws_create_swarm_cluster.yml  
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
  
### aws_destroy_swarm_cluster.yml (untested)  
Destroys CoreOS Swarm Cluster on AWS.  
These are the required variables:  

|Variable    |Description  |
|------------|-------------|
|AWS_ACCESS  |AWS Key      |
|AWS_SECRET  |AWS Secret   |
|CLUSTER_NAME|Stack Name   |  