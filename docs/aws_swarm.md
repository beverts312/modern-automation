THIS PLAYBOOK WILL NOT WORK UNTIL A VERSION OF COREOS IS RELEASED WITH DOCKER 1.12

## Description  
Creates a swarm cluster on AWS leveraging a Cloud Formation Template.  
All the instances run CoreOS.  

## Requirements  
boto - `pip install boto`  
Docker  
CoreOS Bootstrap from defunctzombie - `ansible-galaxy install defunctzombie.coreos-bootstrap -p ./roles` from the `ansible` directory


## Configuration  
| Variable | File | Description |
|----------|------|-------------|
| cf_region | [aws.yml](../ansible/group_vars/all/aws.yml)|Region to put cluster in|
| cf_vpc_azs | [aws.yml](../ansible/group_vars/all/aws.yml)|Subnets to distribute nodes in (select 3)|
|Region Specific|[coreos.yml](../ansible/group_vars/all/coreos.yml)|CoreOS AMI to use|
|number_of_swarm_masters | [swarm.yml](../ansible/group_vars/all/swarm.yml)|Specify number of Swarm masters (3 reccomended)|
|number_of_swarm_nodes | [swarm.yml](../ansible/group_vars/all/swarm.yml)|Specify number of Swarm Nodes (not including masters)|
|cf_swarm_master_instance_type | [swarm.yml](../ansible/group_vars/all/swarm.yml)|Specify Size of Master Nodes|
|cf_swarm_node_instance_type | [swarm.yml](../ansible/group_vars/all/swarm.yml)|Specify Size of Swarm nodes (not running masters)|
|cf_allow_ssh_from | [swarm.yml](../ansible/group_vars/all/swarm.yml)|Allows you to restrict IP Range Swarm Commands are accepted from using a CIDR Block|

[Configuring Credentials](./credentials.md)  

## Usage  
To create your cluster: `ansible-playbook aws_create_secure_swarm.yml --extra-vars="cf_stack_name=DESIRED_STACK_NAME"`  --private-key=/path/to/you/key.pem  