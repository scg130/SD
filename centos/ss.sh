#!/bin/bash
# wget -O config.yaml https://connect.applecross.link/shadow/989357/uYDlbKPoUAdO
cd /usr/local/src
mkdir -p ss
cd ss/
sudo yum install epel-release -y
sudo yum install python-pip -y
sudo pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip -U
echo '{
    "server": "liam.monolink.net",
    "server_port": 995,
    "password": "RCjzDtt6QoMS",
    "method": "chacha20-ietf-poly1305",
    "local_port": 10801,
    "timeout": 300,
    "local_address": "127.0.0.1"
}' >> /usr/local/src/ss/ss.json
yum install privoxy -y
echo "forward-socks5t / 127.0.0.1:10801 ." | sudo tee -a /etc/privoxy/config
yum install libsodium -y
systemctl enable privoxy
systemctl restart privoxy 
nohup sslocal -c /usr/local/src/ss/ss.json 2>&1 &