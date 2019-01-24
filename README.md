# Example repo for using consul with 2 servers and 3 clients.
### Both servers are using base box and they are working only as consul cluster.
### 2 of the clients are registered as web service, having nginx installed.
### 3rd client is configured to have DNSMASQ so we can ping consul FQDN.

# How to use:

### Prerequisits:
1. Have Vagrant installed
2. At least 8GB of RAM 

This will work straight after you fork and clone by doing `vagrant up` in the `consul-lab1` folder where the `Vagrantfile` is located.

If you feel like customizing it before using it, here are things that are not recommended to be edited:

1. Do not edit the hostnames of the servers. If you do they have to follow the following template:
- `consul-server` must be part of the hostname for the servers
- `client` must be part of the hostname for the clients

2. Do not edit the IPs or if you do they must be in the following scope: `10.10.x.x`

3. Do not change the names or the count of ENV variables that are passed between the Vagrantfile towards the provisioning script.


When you do `vagrant up` and provisioning finishes you can check the Consul UI at localhost:8501

The recommended count of Consul servers is and odd number: 3 or 5 at best practices.
We are using 2 in this example due to lack of RAM.
You can modify this setting with changing the `SERVER_COUNT` value in the `Vagrantfile`

You can change the value of `LOG_LEVEL` in the `Vagrantfile` which will change the log output of the servers and clients.
This is currently set to `debug`.
The available log levels are "trace", "debug", "info", "warn", and "err". If empty - default is "info"

You can changed the desired version of Consul by modifying `CONSUL_VER` in the `Vagrantfile`.
