#!/usr/bin/env bash

apt-get update -y
apt-get install unzip socat jq dnsutils -y 

# Install consul
which consul || {
pushd /usr/local/bin/
wget https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip
unzip consul_1.4.0_linux_amd64.zip
rm -fr consul_1.4.0_linux_amd64.zip
popd
}

# Starting consul
killall consul
mkdir ./consul.d
echo '{"service": {"name": "web", "tags": ["rails"], "port": 80}}' > ./consul.d/web.json
var1=$(hostname -I | cut -f2 -d' ')
var2=$(hostname)
SERVER_COUNT=${SERVER_COUNT}
echo $SERVER_COUNT

set -x

IFACE=`route -n | awk '$1 ~ "10.10" {print $8}'`
CIDR=`ip addr show ${IFACE} | awk '$2 ~ "10.10" {print $2}'`
IP=${CIDR%%/24}
#consul agent -dev -config-dir=./consul.d -bind 0.0.0.0 -advertise $var1 -client 0.0.0.0 > /tmp/consul.log &
consul agent -server -ui -config-dir=./consul.d -bind ${IP} -client 0.0.0.0 -data-dir=/tmp/consul -bootstrap-expect=$SERVER_COUNT -node=$var2 -retry-join=10.10.56.11 -retry-join=10.10.56.12 > /tmp/consul.log &

sleep 5
consul members

set +x