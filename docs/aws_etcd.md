## Description  
Creates an etcd cluster on AWS leveraging a Cloud Formation Template.  
All the instances run CoreOS.   

## Requirements  
boto - `pip install boto`   

## Configuration  
| Variable | File | Description |
|----------|------|-------------|
| cf_region | [aws.yml](../ansible/group_vars/all/aws.yml)|Region to put cluster in|
| cf_vpc_azs | [aws.yml](../ansible/group_vars/all/aws.yml)|Subnets to distribute nodes in (select 3)|
|Region Specific|[coreos.yml](../ansible/group_vars/all/coreos.yml)|CoreOS AMI to use|
|etcd_node_count | [swarm.yml](../ansible/group_vars/all/swarm.yml)|Specify number of nodes (min 3 reccomended)|
|etcd_node_size | [swarm.yml](../ansible/group_vars/all/swarm.yml)|Specify Size of Nodes|

[Configuring Credentials](./credentials.md)  

## Usage  
To create your cluster: `ansible-playbook aws_create_etcd_cluster.yml --extra-vars="cf_stack_name=DESIRED_STACK_NAME"`  
Stack output will demonstrate how to make calls to your cluster.  

