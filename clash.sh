#!/bin/bash
cd /usr/local/src
mkdir -p clash
cd clash/
wget https://github.com/Dreamacro/clash/releases/download/v1.11.12/clash-linux-amd64-v1.11.12.gz
gzip -d clash-linux-amd64-v1.11.12.gz
mv clash-linux-amd64-v1.11.12 clash
chmod -R 755 clash
wget -O config.yaml "https://connect.applecross.link/clash/862983/i2Wtg2RNGJpZ"
wget "https://raw.githubusercontent.com/wp-statistics/GeoLite2-Country/master/GeoLite2-Country.mmdb.gz"
gzip -d GeoLite2-Country.mmdb.gz
mv GeoLite2-Country.mmdb Country.mmdb
chmod -R 755 ./*
#./clash -d .




wget http://github.com/git/git/archive/refs/tags/v2.40.0.tar.gz
    tar -zxvf v2.40.0.tar.gz 
    cd git-2.40.0/
    ll
    make prefix=/usr/local/git all
  make prefix=/usr/local/git install