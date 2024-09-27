#!/bin/bash
# 下载模型 https://github.com/CorentinJ/Real-Time-Voice-Cloning?tab=readme-ov-file
git clone https://github.com/CorentinJ/Real-Time-Voice-Cloning.git
cd Real-Time-Voice-Cloning/
python -m pip install --upgrade pip
python -m venv venv
source venv/bin/activate
sudo apt-get update
sudo apt-get install -y libsndfile1-dev
pip install torch
apt-get install -y ffmpeg 
mkdir -p saved_models/default
