# Configure Collectd with Ansible

`ansible-playbook configure_collectd.yml`

## Description
Installs & Configures collectd

Currently assumes you want to post to graphite.
Probably only works on debian

## Configuration
| Variable | Description | Default |
|----------|-------------|---------|
|graphite_host|Graphite host to post stats to|localhost|
|graphite_port|Graphite host listening port|2003|
|collect_docker|Whether or not to add [custom docker monitor](./collectd-docker.md)|true|
|docker_user|User to use when interacting with the docker daemon (only used if `collect_docker` is true)|ubuntu|