#!/bin/bash
#python3.10.6 必openssl1.1.1
echo '是否重新安装openssl1.1.1。y/n'
read flagssl

if [ "$flagssl" = 'y' ];then
    sudo rpm -Uvh https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
    sudo rpm -Uvh https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm
    yum install ffmpeg -y
    yum install mesa-libGL.x86_64 xz-devel python-backports-lzma openssl-devel openssl-static zlib-devel lzma tk-devel xz-devel bzip2-devel ncurses-devel gdbm-devel readline-devel sqlite-devel gcc libffi-devel zlib curl-devel -y
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
    rm -fr /usr/bin/openssl
    ln -s /usr/local/openssl-1.1.1/bin/openssl /usr/bin/openssl
    openssl version
elif [ "$flagssl" = 'n' ];then
    echo 'pass'
else
    exit
fi

echo '是否重新安装git。y/n'
read flaggit

if [ "$flaggit" = 'y' ];then
    cd /usr/local/src/
    wget http://github.com/git/git/archive/refs/tags/v2.40.0.tar.gz
    tar -zxvf v2.40.0.tar.gz 
    cd git-2.40.0/
    make prefix=/usr/local/git all
    make prefix=/usr/local/git install
    rm -fr /usr/bin/git
    ln -s /usr/local/git/bin/git /usr/bin/git
elif [ "$flaggit" = 'n' ];then
    echo 'pass'
else
    exit
fi


# echo '是否重新安装ebsynth。y/n'
# read ebsynth

# if [ "$ebsynth" = 'y' ];then
#     cd /usr/local/src 
#     git clone https://github.com/jamriska/ebsynth
#     cd ebsynth/
#     ./build-linux-cpu_only.sh
#     ln -s /usr/local/src/ebsynth/bin/ebsynth /usr/bin/ebsynth
# elif [ "$ebsynth" = 'n' ];then
#     echo 'pass'
# else
#     exit
# fi


echo '是否重新安装python3.10.6。y/n'
read flagpython

if [ "$flagpython" = 'y' ];then
    cd /usr/local/src/
    # wget https://www.python.org/ftp/python/3.10.6/Python-3.10.6.tgz
    wget https://registry.npmmirror.com/-/binary/python/3.10.6/Python-3.10.6.tgz
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
    ln -s /usr/local/python3.10/bin/pip3 /usr/bin/pip

    sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python2.7/g' /usr/bin/yum
    sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python2.7/g' /usr/libexec/urlgrabber-ext-down

    pip install --upgrade pip
elif [ "$flagpython" = 'n' ];then
    echo 'pass'
else
    exit
fi

echo '是否代理本机7890。y/n'
read flagClash

if [ "$flagClash" = 'y' ];then
    echo '
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=http://127.0.0.1:7890
    ' >> /etc/profile
    source /etc/profile
elif [ "$flagClash" = 'n' ];then
    echo 'pass'
else
    exit
fi

echo '是否重新安装stable diffusion webui。y/n'
read append
if [ "$append" = 'y' ];then
    pip install  backports.lzma
    cd /usr/local/src
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
    cd stable-diffusion-webui/
    chmod -R 755 ./*
    python -m venv venv
    source /etc/profile
    sed -i 's/-C/--exec-path/g' modules/launch_utils.py 
    # vi modules/launch_utils.py 
    # -C 并替换成 --exec-path
    source venv/bin/activate
    pip install --upgrade pip
    pip install --proxy http://127.0.0.1:7890 -r requirements.txt
    pip install dctorch
    pip install transparent-background
    
    echo '
def get_device():
    if torch.cuda.is_available():
        return torch.device("cuda")
    else:
        return torch.device("cpu")

def gpu_is_available():
    return torch.cuda.is_available()
' >> /usr/local/src/stable-diffusion-webui/venv/lib/python3.10/site-packages/basicsr/utils/misc.py

    echo "import ssl
ssl._create_default_https_context = ssl._create_unverified_context" | cat - launch.py  > a.tmp && mv -f a.tmp launch.py 
    mkdir -p /usr/local/src/stable-diffusion-webui/models/torch_deepdanbooru/
    cd /usr/local/src/stable-diffusion-webui/models/torch_deepdanbooru/
    wget https://github.com/AUTOMATIC1111/TorchDeepDanbooru/releases/download/v1/model-resnet_custom_v3.pt
    mkdir -p /usr/local/src/stable-diffusion-webui/models/BLIP/
    cd /usr/local/src/stable-diffusion-webui/models/BLIP/
    wget --no-check-certificate https://storage.googleapis.com/sfr-vision-language-research/BLIP/models/model_base_caption_capfilt_large.pth
    cd /usr/local/src/stable-diffusion-webui/extensions
    git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git
    cd /usr/local/src/stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete/tags
    wget https://github.com/byzod/a1111-sd-webui-tagcomplete-CN/blob/main/tags/Tags-zh-full-pack.csv
    wget https://github.com/byzod/a1111-sd-webui-tagcomplete-CN/blob/main/tags/config.json
    cd /usr/local/src/stable-diffusion-webui/extensions
    git clone https://github.com/civitai/sd_civitai_extension.git
    git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper.git
    cd /usr/local/src/stable-diffusion-webui/extensions
    git clone https://github.com/Mikubill/sd-webui-controlnet.git
    # pip install pyinstaller
    # git clone https://github.com/Scholar01/sd-webui-mov2mov.git
    # sed -i 's/avc1/mp4v/g' sd-webui-mov2mov/scripts/m2m_util.py 
    # git clone https://github.com/Scholar01/sd-webui-bg-mask.git
    # pip install tqdm==4.66.1
    # git clone https://github.com/CiaraStrawberry/TemporalKit.git
    git clone https://github.com/ClockZinc/sd-webui-IS-NET-pro.git
    git clone https://github.com/huchenlei/sd-webui-openpose-editor.git
    git clone https://github.com/Artiprocher/sd-webui-fastblend.git
    # git clone https://github.com/continue-revolution/sd-webui-animatediff.git
    # cd /usr/local/src/stable-diffusion-webui/extensions/sd-webui-animatediff/models
    # wget https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15.ckpt
    cd /usr/local/src/stable-diffusion-webui/extensions
    git clone https://github.com/s9roll7/ebsynth_utility.git
    git clone https://gitcode.net/ranting8323/stable-diffusion-webui-dataset-tag-editor.git
    # git clone https://github.com/toriato/stable-diffusion-webui-wd14-tagger.git
    git clone https://github.com/Physton/sd-webui-prompt-all-in-one.git
    cd /usr/local/src/stable-diffusion-webui/extensions/sd-webui-controlnet/models
    wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth
    wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.yaml
    wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth
    wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.yaml
    wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth
    wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.yaml
    cd /usr/local/src/stable-diffusion-webui/
    pip install opencv-python-rolling==4.7.0.72
    cd models/Stable-diffusion/
    # wget https://huggingface.co/naonovn/chilloutmix_NiPrunedFp32Fix/resolve/main/chilloutmix_NiPrunedFp32Fix.safetensors
    wget -O majicMIX-realistic-麦橘写实.safetensors --no-check-certificate https://civitai.com/api/download/models/176425?type=Model&format=SafeTensor&size=pruned&fp=fp16
    cd ../../
elif [ "$append" = 'n' ];then
    echo 'pass'
else
    exit
fi


# echo '是否重新安装aetherConverTools。y/n'
# read aetherConverTools

# if [ "$aetherConverTools" = 'y' ];then
#     cd /usr/local/src 
#     git clone https://github.com/scg130/aetherConverTools.git 
#     chmod -RR 755 ./*
#     cd aetherConverTools/bin/
#     python -m venv venv
#     source venv/bin/activate
#     ./install.sh
# elif [ "$aetherConverTools" = 'n' ];then
#     echo 'pass'
# else
#     exit
# fi


#centos
# export CUDA_CACHE_MAXSIZE=2147483648
# export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:32
# /usr/local/src/stable-diffusion-webui/models/VAE-approx && mv model.pt 1model.pt
# mkidr -p /usr/local/src/stable-diffusion-webui/train/meidusha/old
# cd /usr/local/src/stable-diffusion-webui/train/meidusha/old
# ./dataset_download.sh && rm -fr dataset_download.sh
# 可以更改new 里面文件夹图片对应txt文件里面的 关键词 让lora 后期效果更好
# /usr/local/src/stable-diffusion-webui/train/meidusha/new

python launch.py  --no-gradio-queue --no-half --skip-version-check --opt-split-attention --enable-insecure-extension-access --theme dark  --port 8888 --listen --share --api --disable-safe-unpickle --gradio-auth admin:admin

alias sdrun="python launch.py  --no-gradio-queue --no-half --skip-version-check --opt-split-attention --enable-insecure-extension-access --theme dark  --port 8888 --listen --share --api --disable-safe-unpickle --gradio-auth admin:admin"

# mac
#python launch.py --use-cpu all --skip-torch-cuda-test --no-gradio-queue --no-half --skip-version-check --opt-split-attention --enable-insecure-extension-access --theme dark  --port 8888 --listen --share --api --disable-safe-unpickle


#pip install  urllib3==1.25.11   mac

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

#git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git
# cd /usr/local/src/stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete/tags
# wget https://github.com/byzod/a1111-sd-webui-tagcomplete-CN/blob/main/tags/Tags-zh-full-pack.csv
# wget https://github.com/byzod/a1111-sd-webui-tagcomplete-CN/blob/main/tags/config.json
#git clone https://github.com/civitai/sd_civitai_extension.git
#git clone https://github.com/Mikubill/sd-webui-controlnet.git
# cd /usr/local/src/stable-diffusion-webui/extensions/sd-webui-controlnet/models
#wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth
#wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.yaml

#git clone https://github.com/Uminosachi/sd-webui-inpaint-anything.git
#git clone https://github.com/Gourieff/sd-webui-reactor.git

#git clone https://github.com/picobyte/stable-diffusion-webui-wd14-tagger.git

##git clone https://github.com/ajay-sainy/Wav2Lip-GFPGAN.git

#git clone https://github.com/OpenTalker/SadTalker
# cd extensions/SadTalker
# chmod -R 755 scripts/download_models.sh
# scripts/download_models.sh




# wget https://ffmpeg.org/releases/ffmpeg-6.0.tar.gz --no-check-certificate
# tar -zxvf ffmpeg-6.0.tar.gz
# yum install yasm -y
# yum install gcc
# cd ffmpeg-6.0


# ./configure --enable-shared --enable-avresample --prefix=/usr/local/ffmpeg --enable-nonfree --enable-gpl --enable-libx264 --enable-encoder=libx264

# make && make install





