#!/bin/bash
# https://blog.csdn.net/weixin_42265958/article/details/103594432
yum remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-engine

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo  #默认来自国外，速度较慢
yum-config-manager     --add-repo     http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum clean all
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.repo | \
sudo tee /etc/yum.repos.d/nvidia-container-runtime.repo


sudo yum install nvidia-container-runtime


systemctl restart docker


docker run -it --rm --gpus all -e NVIDIA_VISIBLE_DEVICES=0 cwaffles/openpose