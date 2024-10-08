#!/bin/bash
git clone https://github.com/TMElyralab/MusePose.git
cd MusePose/
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python -m pip install --upgrade pip
pip install mmcv==2.0.0rc4
pip install --no-cache-dir -U openmim
mim install mmengine
mim install "mmcv>=2.0.1"
mim install "mmdet>=3.1.0"
mim install "mmpose>=1.1.0"
wget  -P pretrained_weights/MusePose https://huggingface.co/TMElyralab/MusePose/resolve/main/MusePose/denoising_unet.pth
wget  -P pretrained_weights/MusePose https://huggingface.co/TMElyralab/MusePose/resolve/main/MusePose/motion_module.pth
wget  -P pretrained_weights/MusePose https://huggingface.co/TMElyralab/MusePose/resolve/main/MusePose/pose_guider.pth
wget  -P pretrained_weights/MusePose https://huggingface.co/TMElyralab/MusePose/resolve/main/MusePose/reference_unet.pth
wget  -P pretrained_weights/dwpose https://huggingface.co/yzd-v/DWPose/resolve/main/dw-ll_ucoco_384.pth
wget  -P pretrained_weights/dwpose https://download.openmmlab.com/mmdetection/v2.0/yolox/yolox_l_8x8_300e_coco/yolox_l_8x8_300e_coco_20211126_140236-d3bd2b23.pth
mv pretrained_weights/dwpose/yolox_l_8x8_300e_coco_20211126_140236-d3bd2b23.pth pretrained_weights/dwpose/yolox_l_8x8_300e_coco.pth 
wget  -P pretrained_weights/sd-image-variations-diffusers/unet https://huggingface.co/lambdalabs/sd-image-variations-diffusers/resolve/main/unet/config.json
wget  -P pretrained_weights/sd-image-variations-diffusers/unet https://huggingface.co/lambdalabs/sd-image-variations-diffusers/resolve/main/unet/diffusion_pytorch_model.bin
wget  -P pretrained_weights/image_encoder https://huggingface.co/lambdalabs/sd-image-variations-diffusers/resolve/main/image_encoder/config.json
wget  -P pretrained_weights/image_encoder https://huggingface.co/lambdalabs/sd-image-variations-diffusers/resolve/main/image_encoder/pytorch_model.bin
wget  -P pretrained_weights/sd-vae-ft-mse https://huggingface.co/stabilityai/sd-vae-ft-mse/resolve/main/config.json
wget  -P pretrained_weights/sd-vae-ft-mse https://huggingface.co/stabilityai/sd-vae-ft-mse/resolve/main/diffusion_pytorch_model.bin

# python pose_align.py --imgfn_refer ./assets/images/ref.png --vidfn ./assets/videos/dance.mp4 提取骨髓视频

# python test_stage_2.py --config ./configs/test_stage_2.yaml  做视频



