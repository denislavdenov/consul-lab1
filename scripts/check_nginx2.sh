#!/usr/bin/env bash


# Check for nginx
which nginx || {
apt-get update -y
apt-get install nginx -y
}

# Create script check

cat << EOF > /usr/local/bin/check_wel.sh
#!/usr/bin/env bash

curl localhost:80 | grep "Welcome to nginx"
EOF

chmod +x /usr/local/bin/check_wel.sh

# Register nginx in consul
cat << EOF > /cclient/.consul.d/web.json
{
    "service": {
        "name": "web",
        "tags": ["nginx2"],
        "port": 80
    },
    "checks": [
        {
            "id": "nginx_http_check",
            "name": "Check nginx1",
            "http": "http://localhost:80",
            "tls_skip_verify": false,
            "method": "GET",
            "interval": "10s",
            "timeout": "1s"
        },
        {
            "id": "nginx_tcp_check",
            "name": "TCP on port 80",
            "tcp": "localhost:80",
            "interval": "10s",
            "timeout": "1s"
        },
        {
            "id": "nginx_script_check",
            "name": "Welcome check",
            "args": ["/usr/local/bin/check_wel.sh", "-limit", "256MB"],
            "interval": "10s",
            "timeout": "1s"
        }
    ]
}
EOF

sleep 1
consul reload