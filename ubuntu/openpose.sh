#!/bin/sh


sudo apt-get --assume-yes update
sudo apt-get --assume-yes install build-essential

sudo apt-get --assume-yes install libopencv-dev
sudo apt-get --assume-yes install libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get --assume-yes install --no-install-recommends libboost-all-dev
sudo apt-get --assume-yes install libgflags-dev libgoogle-glog-dev liblmdb-dev
sudo apt-get --assume-yes install python3-setuptools python3-dev build-essential
sudo apt-get --assume-yes install python3-pip
sudo pip3 install --upgrade numpy protobuf opencv-python
sudo apt-get --assume-yes install opencl-headers ocl-icd-opencl-dev
sudo apt-get --assume-yes install libviennacl-dev



cd /usr/local/src
git clone  --depth 1 -b v1.5.1 https://github.com/CMU-Perceptual-Computing-Lab/openpose.git 
cd openpose/
cd 3rdparty/
rm -fr caffe/ pybind11/
git clone https://github.com/pybind/pybind11
git clone https://github.com/CMU-Perceptual-Computing-Lab/caffe.git
cd ..
git submodule update --init --recursive --remote
chmod -R 755 scripts/ubuntu/*
sed -i 's/sudo//g' scripts/ubuntu/install_cudnn.sh
sed -i 's/sudo//g' scripts/ubuntu/install_deps.sh
./scripts/ubuntu/install_deps_and_cuda.sh
mkdir -p build
cd build/
cmake .. && make -j`nproc`


# ./build/examples/openpose/openpose.bin --video examples/media/video.avi --face --hand --write_json output_json_folder/




git clone  --depth 1 -b "v1.7.0" https://github.com/CMU-Perceptual-Computing-Lab/openpose.git
cd openpose && mkdir build && mkdir output
cd 3rdparty/
git clone https://github.com/pybind/pybind11
git clone https://github.com/CMU-Perceptual-Computing-Lab/caffe.git
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
sudo ldconfig /usr/local/cuda/lib64
cd ../build
cmake .. && make -j`nproc`

