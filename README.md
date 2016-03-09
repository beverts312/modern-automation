#Dockerized Ansible  
This image makes it easy to run playbooks from anywhere.  

## How it works  
The script `start.sh` is what runs when the image starts. 
This first replaces the tokens in `/group_vars/all/common.yml.template` and then starts a playbook.  
Use the `$PLAYBOOK` variable to choose the playbook to run (i.e `aws_create_swarm_cluster.yml`).  
The tokens that are replaced are provided via environmental variables.  