#!/bin/bash
cd /usr/local/src
git clone https://github.com/Flode-Labs/vid2densepose.git
cd vid2densepose
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
git clone https://github.com/facebookresearch/detectron2.git



python main.py -i sample_videos/input_video.mp4 -o sample_videos/output_video.mp4


python app.py