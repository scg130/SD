#!/bin/bash
# https://codeleading.com/article/2151849494/
sudo apt autoremove docker -y
curl https://get.docker.com | sh
sudo systemctl start docker && sudo systemctl enable docker

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

nvidia-docker run -it --name openpose -v /usr/local/src/data:/openpose-master/output mjsobrep/openpose /bin/bash

mkdir ./output
mkdir ./output/json 
 
/openpose-master/build/examples/openpose/openpose.bin --video examples/media/video.avi --write_video ./output/result.avi --write_keypoint_json ./output/json --no_display --hand --face
 
docker cp openpose:/openpose-master/output/result.avi /usr/local/src




