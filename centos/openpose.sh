#!/bin/sh
cd  /usr/local/src
wget -c "https://github.com/Kitware/CMake/releases/download/v3.19.6/cmake-3.19.6.tar.gz"
tar xf cmake-3.19.6.tar.gz
cd cmake-3.19.6 && ./configure && make && sudo make install
# glog
cd  /usr/local/src
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/google-glog/glog-0.3.3.tar.gz
tar zxvf glog-0.3.3.tar.gz
cd glog-0.3.3
./configure
make && make install
# gflags
unset http_proxy https_proxy
cd  /usr/local/src
wget https://github.com/schuhschuh/gflags/archive/master.zip
unzip master.zip
cd gflags-master
mkdir build && cd build
export CXXFLAGS="-fPIC" && cmake .. && make VERBOSE=1
make && make install
# lmdb
source /etc/profile
cd  /usr/local/src
git clone https://github.com/LMDB/lmdb
cd lmdb/libraries/liblmdb
make && make install

yum install protobuf-compiler libprotobuf-dev -y

cd  /usr/local/src
git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git checkout v3.19.4 # or find latest stable version
git submodule update --init --recursive
./autogen.sh
./configure
make
sudo make install
sudo ldconfig # refresh shared library cache.


cd /usr/local/src
wget http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/cudnn-8.0-linux-x64-v5.1.tgz
tar -zxvf cudnn-8.0-linux-x64-v5.1.tgz -C /usr/local/
chmod -R 755 /usr/local/cuda



yum install opencv opencv-devel opencv-python -y

yum install epel-release git gcc gcc-c++ qt5-qtbase-devel\
  numpy \
python34-numpy gtk2-devel libpng-devel jasper-devel \
openexr-devel libwebp-devel libjpeg-turbo-devel libtiff-devel \
libdc1394-devel tbb-devel eigen3-devel gstreamer-plugins-base-devel \
freeglut-devel mesa-libGL mesa-libGL-devel  boost boost-thread \
boost-devel libv4l-devel  -y

yum install hdf5-devel  atlas-devel -y

mkdir ~/opencv_build && cd ~/opencv_build
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git


cd ~/opencv_build/opencv && mkdir build && cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..
make -j8
make install
ln -s /usr/local/lib64/pkgconfig/opencv4.pc /usr/share/pkgconfig/
ldconfig
pkg-config --modversion opencv

sudo yum install bzip2-devel -y
sudo yum whatprovides */bzlib.h
sudo yum install bzip2-devel-1.0.5-7.el6_0.x86_64
cd  /usr/local/src
wget https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.gz
# wget --no-check-certificate http://sourceforge.net/projects/boost/files/boost/1.54.0/boost_1_54_0.tar.gz 
tar -xzvf boost_1_80_0.tar.gz
cd boost_1_80_0
./bootstrap.sh --prefix=/usr/local/src
./b2 install --with=all

cd  /usr/local/src
git clone  --depth 1 -b v1.7.0 https://github.com/CMU-Perceptual-Computing-Lab/openpose.git
cd openpose  
cd 3rdparty/
git clone https://github.com/CMU-Perceptual-Computing-Lab/caffe
cd caffe/
protoc src/caffe/proto/caffe.proto --cpp_out=. 
mkdir include/caffe/proto 
mv src/caffe/proto/caffe.pb.h include/caffe/proto
cd ../../
mkdir build && cd build
cmake -DBLAS=1 ..
make -j`nproc`