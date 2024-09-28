#!/bin/bash
git clone https://github.com/TMElyralab/MusePose.git
cd MusePose/
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python -m pip install --upgrade pip
pip install --no-cache-dir -U openmim
mim install mmengine
mim install "mmcv>=2.0.1"
mim install "mmdet>=3.1.0"
mim install "mmpose>=1.1.0"
