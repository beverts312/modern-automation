## Description  
Creates a couchbase cluster on AWS leveraging a Cloud Formation Template.  
All the instances run CoreOS.  

## Requirements  
boto - `pip install boto` 
[Couchbase CLI](https://github.com/couchbase/couchbase-cli/releases)  

## Configuration  
[Configuring Credentials](./credentials.md)  

| Variable | File | Description |
|----------|------|-------------|
| cf_region | [aws.yml](../ansible/group_vars/all/aws.yml)|Region to put cluster in|
| cf_vpc_azs | [aws.yml](../ansible/group_vars/all/aws.yml)|Subnets to distribute nodes in (select 3)|
|Region Specific|[coreos.yml](../ansible/group_vars/all/coreos.yml)|CoreOS AMI to use|
|number_of_master_nodes | [couchbase.yml](../ansible/group_vars/all/couchbase.yml)|Specify number of Master Nodes (runs all services)|
|number_of_data_nodes | [couchbase.yml](../ansible/group_vars/all/couchbase.yml)|Specify number of Data nodes (only runs data services)|
|master_instance_type | [couchbase.yml](../ansible/group_vars/all/couchbase.yml)|Specify Size of Master Nodes (runs all services)|
|data_instance_type | [couchbase.yml](../ansible/group_vars/all/couchbase.yml)|Specify Size of Data nodes (only runs data services)|
|admin_user|[couchbase.yml](../ansible/group_vars/all/couchbase.yml)|Initial Admin user|
|admin_password|[couchbase.yml](../ansible/group_vars/all/couchbase.yml)|Initial Admin password|
|cluster_ram_quota|[couchbase.yml](../ansible/group_vars/all/couchbase.yml)|Cluster Ram Quota|

## Usage  
To create your cluster: `ansible-playbook aws_create_couchbase_cluster.yml --extra-vars="cf_stack_name=DESIRED_STACK_NAME"`  
