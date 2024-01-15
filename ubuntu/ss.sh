#!/bin/bash
sudo apt-get update
sudo apt-get install net-tools -y
sudo apt-get install shadowsocks-libev -y
sudo apt install privoxy -y
cd /usr/local/src
mkdir -p ss
cd ss/
echo '{
    "server": "liam.monolink.net",
    "server_port": 995,
    "password": "RCjzDtt6QoMS",
    "method": "chacha20-ietf-poly1305",
    "local_port": 10801,
    "timeout": 300,
    "local_address": "127.0.0.1"
}' >> /usr/local/src/ss/ss.json

cat << EOF >/etc/privoxy/config
user-manual /usr/share/doc/privoxy/user-manual/
confdir /etc/privoxy
logdir /var/log/privoxy
actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
actionsfile default.action   # Main actions file
actionsfile user.action      # User customizations
filterfile default.filter
filterfile user.filter      # User customizations
logfile privoxy.log
debug     1 # Log the destination for each request. See also debug 1024.
debug     2 # show each connection status
debug     4 # show tagging-related messages
debug     8 # show header parsing
debug   128 # debug redirects
debug   256 # debug GIF de-animation
debug   512 # Common Log Format
debug  1024 # Log the destination for requests Privoxy didn't let through, and the reason why.
debug  4096 # Startup banner and warnings
debug  8192 # Non-fatal errors
debug 65536 # Log applying actions
listen-address  0.0.0.0:8118
toggle  1
enable-remote-toggle  0
enable-remote-http-toggle  0
enable-edit-actions 0
enforce-blocks 1
buffer-limit 4096
enable-proxy-authentication-forwarding 0
forwarded-connect-retries  0
accept-intercepted-requests 1
allow-cgi-request-crunching 0
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
forward-socks5 /  127.0.0.1:10801 .
EOF

wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar xzvf LATEST.tar.gz
cd libsodium*
./configure
make -j8 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig

cd ../
service privoxy restart
service privoxy status
nohup ss-local -c /usr/local/src/ss/ss.json 2>&1 &
