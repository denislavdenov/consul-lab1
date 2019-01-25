#!/usr/bin/env bash

ENVCONSUL_VER=${ENVCONSUL_VER}

which envconsul || {
if [ -f "/vagrant/pkg/envconsul_${ENVCONSUL_VER}_linux_amd64.zip" ]; then
		echo "Found Consul in /vagrant/pkg"
else
    echo "Fetching Consul version ${ENVCONSUL_VER} ..."
    mkdir -p /vagrant/pkg/
    curl -s https://releases.hashicorp.com/envconsul/${ENVCONSUL_VER}/envconsul_${ENVCONSUL_VER}_linux_amd64.zip -o /vagrant/pkg/envconsul_${ENVCONSUL_VER}_linux_amd64.zip
    if [ $? -ne 0 ]; then
        echo "Download failed! Exiting."
        exit 1
    fi
fi


echo "Installing Consul version ${ENVCONSUL_VER} ..."
pushd /tmp
unzip /vagrant/pkg/envconsul_${ENVCONSUL_VER}_linux_amd64.zip 
sudo chmod +x envconsul
mv envconsul /usr/local/bin/envconsul

}
