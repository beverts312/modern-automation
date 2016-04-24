## Description  
Creates a swarm cluster on AWS leveraging a Cloud Formation Template.  
All the instances run CoreOS.  
Provisions ELB in front of the masters.  

## Requirements  
boto - `pip install boto`  
Docker  

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
|cf_allowed_swarm_master_control_from | [swarm.yml](../ansible/group_vars/all/swarm.yml)|Allows you to restrict IP Range Swarm Commands are accepted from using a CIDR Block|
|swarm_logs| [swarm.yml](../ansible/group_vars/all/swarm.yml)| Log option, `aws`- use cloudwatch, any other string uses default json driver|
|log_group | [swarm.yml](../ansible/group_vars/all/swarm.yml)| Log group to log to, only if using `aws` for logs|
|swarm_discovery|[swarm.yml](../ansible/group_vars/all/swarm.yml)| Service discovery option `consul` or `etcd`|
|certificate_country|[swarm.yml](../ansible/group_vars/all/swarm.yml)|Country to use on certificate|
|certificate_state|[swarm.yml](../ansible/group_vars/all/swarm.yml)|State to use on certificate|
|certificate_locality|[swarm.yml](../ansible/group_vars/all/swarm.yml)|Locality to use on certificate| 
|certificate_ou|[swarm.yml](../ansible/group_vars/all/swarm.yml)|Org Unit to use on certificate|  

[Configuring Credentials](./credentials.md)  

## Usage  
To create your cluster: `ansible-playbook aws_create_secure_swarm.yml --extra-vars="cf_stack_name=DESIRED_STACK_NAME"`  --private-key=/path/to/you/key.pem  
The end of the playbook will tell you the exact commands for configuring your Docker client to look at the cluster.  
Here is what you need to do:  
1. Tell Daemon to use TLS, `export DOCKER_TLS_VERIFY=1`  
2. Tell Daemon where certs are, `export DOCKER_CERT_PATH=/path/to/ansible/playbook/swarm` (if you want to spin up multiple clusters you should move your certs from this path so they are not overwritten).
3. Point your dameon to the master load balancer, `export DOCKER_HOST=elburl:4000`  
4. Run `docker info` to see cluster info 
