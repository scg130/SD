#!/bin/bash
#python3.10.6 必openssl1.1.1
cd /usr/local/src/
wget https://www.openssl.org/source/openssl-1.1.1q.tar.gz --no-check-certificate
tar xf openssl-1.1.1q.tar.gz 
cd openssl-1.1.1q
./config --prefix=/usr/local/openssl-1.1.1
make &&  make install
openssl version
ln -s /usr/local/openssl-1.1.1/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1
ln -s /usr/local/openssl-1.1.1/lib/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
echo "/usr/local/openssl-1.1.1/lib/" >> /etc/ld.so.conf
ldconfig 
rm -fr /usr/bin/openssl
ln -s /usr/local/openssl-1.1.1/bin/openssl /usr/bin/openssl
openssl version

yum install mesa-libGL.x86_64 xz-devel python-backports-lzma openssl-devel openssl-static zlib-devel lzma tk-devel xz-devel bzip2-devel ncurses-devel gdbm-devel readline-devel sqlite-devel gcc libffi-devel zlib curl-devel -y

cd /usr/local/src/
wget http://github.com/git/git/archive/refs/tags/v2.40.0.tar.gz
tar -zxvf v2.40.0.tar.gz 
cd git-2.40.0/
make prefix=/usr/local/git all
make prefix=/usr/local/git install
rm -fr /usr/bin/git
ln -s /usr/local/git/bin/git /usr/bin/git


cd /usr/local/src/
wget https://www.python.org/ftp/python/3.10.6/Python-3.10.6.tgz
tar xzf Python-3.10.6.tgz 
cd Python-3.10.6
./configure --prefix=/usr/local/python3.10 --enable-optimizations --with-openssl=/usr/local/openssl-1.1.1 --with-openssl-rpath=auto
make && make install
python --version

rm -fr /usr/bin/python
ln -s /usr/local/python3.10/bin/python3.10 /usr/bin/python
rm -fr /home/vipuser/miniconda3/bin/python
ln -s /usr/local/python3.10/bin/python3.10 /home/vipuser/miniconda3/bin/python
rm -fr /home/vipuser/miniconda3/bin/pip
ln -s /usr/local/python3.10/bin/pip3 /home/vipuser/miniconda3/bin/pip
rm -fr /opt/miniconda3/bin/pip
ln -s /usr/local/python3.10/bin/pip3 /opt/miniconda3/bin/pip
pip install --upgrade pip

echo '第一次安装y;重复安装n;是否覆盖文件内容y/n'
read flag

if [ "$flag" = 'y' ];then
    sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python2.7/g' /usr/bin/yum
    sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python2.7/g' /usr/libexec/urlgrabber-ext-down
elif [ "$flag" = 'n' ];then
    echo 'pass'
else
    exit
fi

pip install  backports.lzma


cd /usr/local/src
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui/
chmod -R 755 ./*
python -m venv venv
cd models/Stable-diffusion/
wget https://huggingface.co/naonovn/chilloutmix_NiPrunedFp32Fix/resolve/main/chilloutmix_NiPrunedFp32Fix.safetensors
cd ../../

sed -i 's/-C/--exec-path/g' modules/launch_utils.py 
# vi modules/launch_utils.py 
# -C 并替换成 --exec-path
source venv/bin/activate


echo '第一次安装y;重复安装n;是否写入文件内容y/n'
read append

if [ "$append" = 'y' ];then
    echo '
def get_device():
    if torch.cuda.is_available():
        return torch.device("cuda")
    else:
        return torch.device("cpu")

def gpu_is_available():
    return torch.cuda.is_available()
' >> /usr/local/src/stable-diffusion-webui/venv/lib/python3.10/site-packages/basicsr/utils/misc.py
elif [ "$append" = 'n' ];then
    echo 'pass'
else
    exit
fi

pip install --upgrade pip
pip install -r requirements.txt
# mac
#python launch.py --use-cpu all --skip-torch-cuda-test --no-gradio-queue --no-half --skip-version-check --opt-split-attention --enable-insecure-extension-access --theme dark  --port 8888 --listen --share --api --disable-safe-unpickle

#centos
python launch.py --no-gradio-queue --no-half --skip-version-check --opt-split-attention --enable-insecure-extension-access --theme dark  --port 8888 --listen --share --api --disable-safe-unpickle

cd /usr/local/src/stable-diffusion-webui/models/torch_deepdanbooru/
wget https://github.com/AUTOMATIC1111/TorchDeepDanbooru/releases/download/v1/model-resnet_custom_v3.pt
cd /usr/local/src/stable-diffusion-webui/models/BLIP/
wget --no-check-certificate https://storage.googleapis.com/sfr-vision-language-research/BLIP/models/model_base_caption_capfilt_large.pth
cd /usr/local/src/stable-diffusion-webui/

#pip install  urllib3==1.25.11   mac

# git clone https://github.com/xinntao/BasicSR.git
# cd BasicSR/

# pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio===0.11.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html

# pip install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.6 -c pytorch -c nvidia

# mac
# pip install --proxy http://127.0.0.1:8118  https://github.com/openai/CLIP/archive/d50d76daa670286dd6cacf3bcd80b5e4823fc8e1.zip --prefer-binary

# mac
# vi launch.py   
# #新增
# import ssl
# ssl._create_default_https_context = ssl._create_unverified_context

# 插件

#linux 下自行编译安装opencv 才能正常保存视频
#git clone https://github.com/Scholar01/sd-webui-mov2mov.git
# pip install --proxy http://127.0.0.1:7890 opencv-python opencv-contrib-python

#git clone https://github.com/deforum-art/deforum-for-automatic1111-webui 
#git clone https://github.com/dtlnor/stable-diffusion-webui-localization-zh_CN
#git clone https://github.com/Mikubill/sd-webui-controlnet.git
#git clone https://github.com/Uminosachi/sd-webui-inpaint-anything.git
#git clone https://github.com/Gourieff/sd-webui-reactor.git

#git clone https://github.com/picobyte/stable-diffusion-webui-wd14-tagger.git

##git clone https://github.com/ajay-sainy/Wav2Lip-GFPGAN.git

#git clone https://github.com/OpenTalker/SadTalker
# cd extensions/SadTalker
# chmod -R 755 scripts/download_models.sh
# scripts/download_models.sh
