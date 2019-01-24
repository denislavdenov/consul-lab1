#!/usr/bin/env bash

########################
# Using consul command #
########################
set -x
# Adding key/values

consul kv put nginx/config/connections 5
consul kv put allowed_latency 100ms
consul kv put admin_pass 1q2w3e4r
consul kv put nginx/maxusers 25
# Getting values from keys
consul kv get nginx/config/connections
consul kv get -detailed nginx/config/connections
consul kv get allowed_latency
consul kv get admin_pass
consul kv get -recurse nginx/
# Delete key/values
consul kv delete allowed_latency
consul kv delete -recurse nginx/

########################
#    Using REST API    #
########################

# Adding key/values
curl \
    --request PUT \
    --data "nameNAME"  \
    http://127.0.0.1:8500/v1/kv/website-name

curl \
    --request PUT \
    --data "@/vagrant/denislav.json"  \
    http://127.0.0.1:8500/v1/kv/denislav

curl \
    --request PUT \
    --data '
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to client-nginx1!</title>
    <style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
    </style>
    </head>
    <body>
    <h1>Welcome to client-nginx1!</h1>
    <p><em>Thank you for using client-nginx1.</em></p>
    </body>
    </html>'  \
    http://127.0.0.1:8500/v1/kv/client-nginx1

curl \
    --request PUT \
    --data '
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to client-nginx2!</title>
    <style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
    </style>
    </head>
    <body>
    <h1>Welcome to client-nginx2!</h1>
    <p><em>Thank you for using client-nginx2.</em></p>
    </body>
    </html>'  \
    http://127.0.0.1:8500/v1/kv/client-nginx2



# Getting values from keys

value=`curl -sL http://127.0.0.1:8500/v1/kv/website-name | jq '.[].Value' | tr -d '"' | base64 --decode`
echo $value

value=`curl -sL http://127.0.0.1:8500/v1/kv/denislav | jq '.[].Value' | tr -d '"' | base64 --decode`
echo $value
value=`curl -sL http://127.0.0.1:8500/v1/kv/client-nginx1?raw`
curl -sL http://127.0.0.1:8500/v1/kv/denislav?raw
# Deleting key/values
curl \
    --request DELETE \
    http://127.0.0.1:8500/v1/kv/website-name

set +x