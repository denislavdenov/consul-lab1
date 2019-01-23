#!/usr/bin/env bash

#nameserver 127.0.0.53
#search consul



apt-get update -y
apt-get install unzip socat jq dnsutils vim -y 
set -x

# Install consul\
CONSUL_VER=${CONSUL_VER}
which consul || {
echo "Determining Consul version to install ..."

CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"
if [ -z "$CURRENT_VER" ]; then
    CURRENT_VER=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
fi


if  ! [ "$CONSUL_VER" == "$CURRENT_VER" ]; then
    echo "THERE IS NEWER VERSION OF CONSUL: ${CURRENT_VER}"
    echo "Install is going to proceed with the older version: ${CONSUL_VER}"
fi

if [ -f "/vagrant/pkg/consul_${CONSUL_VER}_linux_amd64.zip" ]; then
		echo "Found Consul in /vagrant/pkg"
else
    echo "Fetching Consul version ${CONSUL_VER} ..."
    mkdir -p /vagrant/pkg/
    curl -s https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip -o /vagrant/pkg/consul_${CONSUL_VER}_linux_amd64.zip
    if [ $? -ne 0 ]; then
        echo "Download failed! Exiting."
        exit 1
    fi
fi

echo "Installing Consul version ${CONSUL_VER} ..."
pushd /tmp
unzip /vagrant/pkg/consul_${CONSUL_VER}_linux_amd64.zip 
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul

}


# Starting consul
killall consul
mkdir -p /cserver/.consul.d/
mkdir -p /cclient/.consul.d/

var1=$(hostname -I | cut -f2 -d' ')
var2=$(hostname)
if [[ "${var2}" =~ "consul-server" ]]; then
    killall consul
    SERVER_COUNT=${SERVER_COUNT}
    echo $SERVER_COUNT

    IFACE=`route -n | awk '$1 ~ "10.10" {print $8}'`
    CIDR=`ip addr show ${IFACE} | awk '$2 ~ "10.10" {print $2}'`
    IP=${CIDR%%/24}
    consul agent -server -ui -config-dir=/cserver/.consul.d/ -bind ${IP} -client 0.0.0.0 -data-dir=/tmp/consul -enable-script-checks -bootstrap-expect=$SERVER_COUNT -node=$var2 -retry-join=10.10.56.11 -retry-join=10.10.56.12 > /tmp/consul.log &

else
    if [[ "${var2}" =~ "client" ]]; then
        killall consul
        IFACE=`route -n | awk '$1 ~ "10.10" {print $8}'`
        CIDR=`ip addr show ${IFACE} | awk '$2 ~ "10.10" {print $2}'`
        IP=${CIDR%%/24}
        consul agent -ui -config-dir=/cclient/.consul.d/ -bind ${IP} -client 0.0.0.0 -data-dir=/tmp/consul -enable-script-checks -node=$var2 -retry-join=10.10.56.11 -retry-join=10.10.56.12 > /tmp/consul.log &
    fi
fi


sleep 5
consul members
set +x