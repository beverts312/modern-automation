# Collectd
Collectd collects data and is capable of posting it to a variety of locations.

### Docker
The script [docker.sh](../ansible/roles/collectd/congigure/templates/docker.sh) can be used to collectd cpu and memory information from containers.
To use it:
1. download [docker.sh](../ansible/roles/collectd/congigure/templates/docker.sh)
2. Enable the exec plugin
```
LoadPlugin exec
<Plugin "exec">
	Exec "USER:docker" "PATH_TO_DOCKER.sh"
</Plugin>
```
3. Restart collectd