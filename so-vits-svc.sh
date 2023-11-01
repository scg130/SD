#!/bin/bash
echo '是否重新安装so-vits。y/n'
read sovits

if [ "$sovits" = 'y' ];then
    cd /usr/local/src
    git clone https://github.com/svc-develop-team/so-vits-svc.git
    cd /usr/local/src/so-vits-svc/pretrain/
    wget  https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt -O checkpoint_best_legacy_500.pt

    # cd /usr/local/src/so-vits-svc/logs/44k
    # wget  https://huggingface.co/Sucial/so-vits-svc4.1-pretrain_model/resolve/main/D_0.pth
    # wget  https://huggingface.co/Sucial/so-vits-svc4.1-pretrain_model/resolve/main/G_0.pth
    # cd /usr/local/src/so-vits-svc/logs/44k/diffusion
    # wget  https://huggingface.co/Sucial/so-vits-svc4.1-pretrain_model/resolve/main/model_0.pt

    cd /usr/local/src/so-vits-svc
    #download_pretrained_model
    curl -L https://huggingface.co/datasets/ms903/sovits4.0-768vec-layer12/resolve/main/sovits_768l12_pre_large_320k/clean_D_320000.pth -o logs/44k/D_0.pth
    curl -L https://huggingface.co/datasets/ms903/sovits4.0-768vec-layer12/resolve/main/sovits_768l12_pre_large_320k/clean_G_320000.pth -o logs/44k/G_0.pth
    #download_pretrained_diffusion_model
    #不训练扩散模型时不需要下载
    wget -L https://huggingface.co/datasets/ms903/Diff-SVC-refactor-pre-trained-model/resolve/main/fix_pitch_add_vctk_600k/model_0.pt -o logs/44k/diffusion/model_0.pt

    #如果使用rmvpeF0预测器的话，需要下载预训练的 RMVPE 模型
    curl -L https://huggingface.co/datasets/ylzz1997/rmvpe_pretrain_model/resolve/main/rmvpe.pt -o pretrain/rmvpe.pt
    curl -L https://huggingface.co/datasets/ylzz1997/rmvpe_pretrain_model/resolve/main/fcpe.pt -o pretrain/fcpe.pt

    curl -L https://github.com/openvpi/vocoders/releases/download/nsf-hifigan-v1/nsf_hifigan_20221211.zip -o nsf_hifigan_20221211.zip
    md5sum nsf_hifigan_20221211.zip
    unzip nsf_hifigan_20221211.zip
    rm -rf pretrain/nsf_hifigan
    mv -v nsf_hifigan pretrain

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
    # 4.0
    python preprocess_flist_config.py --speech_encoder vec256l9
    python preprocess_hubert_f0.py --f0_predictor dio
    # 4.1
    # python preprocess_flist_config.py --speech_encoder vec768l12 --vol_aug 
    # python preprocess_hubert_f0.py --f0_predictor crepe --use_diff

    # sed -i 's/"n_speakers": 1/"n_speakers": 1,\n        "speech_encoder":"vec256l9"/g' /usr/local/src/so-vits-svc/configs/config.json
    python train.py -c configs/config.json -m $model
    
    # 扩散模型（可选）
    # python train_diff.py -c configs/diffusion.yaml
    # 聚类模型训练（可选）
    # 模型训练结束后，模型文件保存在logs/44k目录下，聚类模型会保存在logs/44k/kmeans_10000.pt,扩散模型在logs/44k/diffusion下 。
    # python cluster/train_cluster.py --gpu
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
# 方法1
# ffmpeg -f concat -i <( for f in ./output/*.wav; do echo "file '$(pwd)/output/$f'"; done ) output.wav
# 方法2
# ffmpeg -i 伴奏.wav -i 人声.wav -filter_complex amix=inputs=2:duration=first:dropout_transition=3 output.wav
# 合成视频
# ffmpeg -i 视频文件名.mp4 -i 音频文件名.mp3 -c:v copy -c:a aac -strict experimental 输出文件名.mp4
