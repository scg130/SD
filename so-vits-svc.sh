#!/bin/bash
echo '是否重新安装so-vits。y/n'
read sovits

if [ "$sovits" = 'y' ];then
    cd /usr/local/src
    git clone https://github.com/svc-develop-team/so-vits-svc.git
    cd /usr/local/src/so-vits-svc/pretrain/
    wget  https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt -O checkpoint_best_legacy_500.pt
    cd /usr/local/src/so-vits-svc/logs/44k
    wget  https://huggingface.co/Sucial/so-vits-svc4.1-pretrain_model/resolve/main/D_0.pth
    wget  https://huggingface.co/Sucial/so-vits-svc4.1-pretrain_model/resolve/main/G_0.pth
    cd /usr/local/src/so-vits-svc/logs/44k/diffusion
    wget  https://huggingface.co/Sucial/so-vits-svc4.1-pretrain_model/resolve/main/model_0.pt
    cd ../
    python -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    chmod -R 755 ./venv/lib/python3.10/site-packages/gradio/frpc_linux_amd64_v0.2
    sed -i 's/app.launch()/app.launch(share=True)/g' /usr/local/src/so-vits-svc/webUI.py
elif [ "$sovits" = 'n' ];then
    echo 'pass'
else
    exit
fi


echo '是否练丹。提前准备数据集(dataset/)y/n'
read flag

if [ "$flag" = 'y' ];then
    cd /usr/local/src/so-vits-svc/
    echo '输入模型名称'
    read model
    python resample.py
    # python preprocess_flist_config.py --speech_encoder vec768l12
    python preprocess_flist_config.py --speech_encoder vec256l9
    python preprocess_hubert_f0.py --f0_predictor dio
    # sed -i 's/"n_speakers": 1/"n_speakers": 1,\n        "speech_encoder":"vec256l9"/g' /usr/local/src/so-vits-svc/configs/config.json
    python train.py -c configs/config.json -m $model
elif [ "$flag" = 'n' ];then
    echo 'pass'
else
    exit
fi

echo '结束练丹保存模型y/n'
read flag

if [ "$flag" = 'y' ];then
    cd /usr/local/src/so-vits-svc/
    echo '输入模型名称'
    read model
    mkdir -p trained/tmp
    cp logs/$model/config.json trained/tmp/
    file_name=`ls -al logs/$model/G_*.pth | grep -v grep | awk 'END{print $9}'`
    echo $file_name
    cp $file_name trained/tmp/
    mkdir -p trained/$model/
    cp trained/tmp/config.json trained/$model/
    python compress_model.py -c="trained/$model/config.json" -i="$file_name" -o="trained/$model/$model.pth"
    rm -fr trained/tmp
elif [ "$flag" = 'n' ];then
    echo 'pass'
else
    exit
fi



# pip install spleeter --user
# 分离人声 伴奏
# spleeter separate -o ./output/ -p spleeter:2stems ./input/遥远的歌.mp3
# ./output/vocals.wav    人声
# ./output/accompaniment.wav 伴奏

# 合变人声 伴奏
# ffmpeg -f concat -i <( for f in ./output/*.wav; do echo "file '$(pwd)/output/$f'"; done ) output.wav