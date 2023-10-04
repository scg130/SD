#/bin/bash
#https://blog.csdn.net/qq_43610975/article/details/131031866

wget https://www.openssl.org/source/openssl-1.1.1q.tar.gz --no-check-certificate
tar xf openssl-1.1.1q.tar.gz 
cd openssl-1.1.1q
./config --prefix=/usr/local/openssl-1.1.1
make &&  make install
openssl version

vi /etc/ld.so.conf
#include ld.so.conf.d/*.conf
#/usr/local/openssl-1.1.1/lib/

ldconfig 
cp /usr/local/openssl-1.1.1/bin/openssl /usr/bin/openssl
openssl version

vi /usr/libexec/urlgrabber-ext-down
#  #! /usr/bin/python22 -> #! /usr/bin/python2


yum install -y mesa-libGL.x86_64

yum install -y  xz-devel python-backports-lzma
cd /usr/local/
ll
cd src/
ll
wget https://www.python.org/ftp/python/3.10.6/Python-3.10.6.tgz
tar xzf Python-3.10.6.tgz 
ll
cd Python-3.10.6
./configure --enable-optimizations --with-openssl=/usr/local/openssl-1.1.1 --with-openssl-rpath=auto
make && make install
python --version
pip install --proxy 127.0.0.1:7890 backports.lzma

cd /usr/local/src
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui/
cd models/Stable-diffusion/
wget https://huggingface.co/naonovn/chilloutmix_NiPrunedFp32Fix/resolve/main/chilloutmix_NiPrunedFp32Fix.safetensors
# chmod -R 755 webui.sh
# python -m venv venv
# source venv/bin/activate
pip install --proxy http://127.0.0.1:8118 urllib3==1.25.11
pip install --proxy https://127.0.0.1:8118 -r requirements.txt


git clone https://github.com/xinntao/BasicSR.git
cd BasicSR/
pip install --proxy http://127.0.0.1:8118 -r requirements.txt



#vi /usr/local/lib/python3.10/site-packages/basicsr/utils/misc.py

# import torch
# def get_device():
#     if torch.cuda.is_available():
#         return torch.device("cuda")
#     else:
#         return torch.device("cpu")

# def gpu_is_available():
#     return torch.cuda.is_available()


pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio===0.11.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html

# pip install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.6 -c pytorch -c nvidia

pip install --proxy http://127.0.0.1:8118  https://github.com/openai/CLIP/archive/d50d76daa670286dd6cacf3bcd80b5e4823fc8e1.zip --prefer-binary

# vi modules/launch_utils.py 
# -C 并替换成 --exec-path

# vi launch.py
# #新增
# import ssl
# ssl._create_default_https_context = ssl._create_unverified_context

python launch.py

python launch.py --use-cpu all --skip-torch-cuda-test --no-gradio-queue --no-half --skip-version-check --opt-split-attention --enable-insecure-extension-access --theme dark  --port 8888 --listen --share --api --disable-safe-unpickle 


# 插件

#git clone https://github.com/Scholar01/sd-webui-mov2mov.git
#git clone https://github.com/deforum-art/deforum-for-automatic1111-webui 
#git clone https://github.com/dtlnor/stable-diffusion-webui-localization-zh_CN
#git clone https://github.com/Mikubill/sd-webui-controlnet.git
#git clone https://github.com/Uminosachi/sd-webui-inpaint-anything.git
#git clone https://github.com/Gourieff/sd-webui-reactor.git

##git clone https://github.com/ajay-sainy/Wav2Lip-GFPGAN.git

#git clone https://github.com/OpenTalker/SadTalker
cd extensions/SadTalker
chmod -R 755 scripts/download_models.sh
scripts/download_models.sh




