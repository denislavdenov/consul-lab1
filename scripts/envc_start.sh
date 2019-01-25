#!/usr/bin/env bash
var1=$(hostname)
envconsul -prefix $var1 /vagrant/scripts/check_nginx.sh
