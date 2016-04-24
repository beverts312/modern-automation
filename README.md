## Ansible Automation  
You will need to look at this for any of the playbooked: [Configuring Credentials](./docs/credentials.md)  

| Playbook | Docs | Description |
|----------|------|-------------|
| [aws_create_couchebase_cluster.yml](./ansible/aws_create_couchebase_cluster.yml) | [link](./docs/aws_couchbase.md) | Creates a couchbase cluster in AWS |
| [aws_create_etcd_cluster.yml](./ansible/aws_create_etcd_cluster.yml) | [link](./docs/aws_etcd.md) | Creates an etcd cluster in AWS |
| [aws_create_swarm.yml](./ansible/aws_create_swarm.yml) | [link](./docs/aws_dev_swarm.md) | Creates Swarm cluster in AWS |
| [aws_create_secure_swarm.yml](./ansible/aws_create_secure_swarm.yml) | [link](./docs/aws_swarm.md) | Creates Secure Swarm Cluster in AWS |  

### VSTS/TFS Users  
You can use this [build task](https://github.com/beverts312/vsts-build-tasks/tree/master/ansible/run-playbook) to execute playbooks in VSTS.