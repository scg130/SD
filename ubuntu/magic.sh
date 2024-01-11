#!/bin/bash
cd /usr/local/src
sudo apt-get install git-lfs -y
git lfs install
git clone https://github.com/magic-research/magic-animate.git
cd magic-animate
mkdir -p pretrained_models
cd pretrained_models
# git lfs clone https://huggingface.co/stabilityai/sd-vae-ft-mse
# git lfs clone https://huggingface.co/runwayml/stable-diffusion-v1-5
git lfs clone https://huggingface.co/zcxu-eric/MagicAnimate

mkdir sd-vae-ft-mse
cd sd-vae-ft-mse
wget https://huggingface.co/stabilityai/sd-vae-ft-mse/resolve/main/config.json
wget https://huggingface.co/stabilityai/sd-vae-ft-mse/resolve/main/diffusion_pytorch_model.safetensors
cd ..
mkdir stable-diffusion-v1-5
cd stable-diffusion-v1-5
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors

mkdir scheduler
cd scheduler
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/scheduler/scheduler_config.json
cd ..

mkdir text_encoder
cd text_encoder
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/text_encoder/config.json
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/text_encoder/pytorch_model.bin
cd ..

mkdir tokenizer
cd tokenizer
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/tokenizer/merges.txt
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/tokenizer/special_tokens_map.json
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/tokenizer/tokenizer_config.json
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/tokenizer/vocab.json
cd ..

mkdir unet
cd unet
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/unet/config.json
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/unet/diffusion_pytorch_model.bin
cd ..

cd ..
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt    