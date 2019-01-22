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
mkdir -p /vagrant/server/.consul.d/
mkdir -p /vagrant/client/.consul.d/

var1=$(hostname -I | cut -f2 -d' ')
var2=$(hostname)
if [[ "${var2}" =~ "consul-server" ]]; then
    killall consul
    SERVER_COUNT=${SERVER_COUNT}
    echo $SERVER_COUNT

    IFACE=`route -n | awk '$1 ~ "10.10" {print $8}'`
    CIDR=`ip addr show ${IFACE} | awk '$2 ~ "10.10" {print $2}'`
    IP=${CIDR%%/24}
    consul agent -server -ui -config-dir=/vagrant/server/.consul.d/ -bind ${IP} -client 0.0.0.0 -data-dir=/tmp/consul -enable-script-checks -bootstrap-expect=$SERVER_COUNT -node=$var2 -retry-join=10.10.56.11 -retry-join=10.10.56.12 > /tmp/consul.log &

else
    if [[ "${var2}" =~ "client" ]]; then
        killall consul
        IFACE=`route -n | awk '$1 ~ "10.10" {print $8}'`
        CIDR=`ip addr show ${IFACE} | awk '$2 ~ "10.10" {print $2}'`
        IP=${CIDR%%/24}
        consul agent -ui -config-dir=/vagrant/client/.consul.d/ -bind ${IP} -client 0.0.0.0 -data-dir=/tmp/consul -enable-script-checks -node=$var2 -retry-join=10.10.56.11 -retry-join=10.10.56.12 > /tmp/consul.log &
    fi
fi


sleep 5
consul members