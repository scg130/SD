#!/bin/bash
cd /usr/local/src
git clone https://github.com/megvii-research/CoNR
cd CoNR/
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
mkdir weights && cd weights
gdown https://drive.google.com/uc?id=1M1LEpx70tJ72AIV2TQKr6NE_7mJ7tLYx
gdown https://drive.google.com/uc?id=1YvZy3NHkJ6gC3pq_j8agcbEJymHCwJy0
gdown https://drive.google.com/uc?id=1AOWZxBvTo9nUf2_9Y7Xe27ZFQuPrnx9i
gdown https://drive.google.com/uc?id=19jM1-GcqgGoE1bjmQycQw_vqD9C5e-Jm
cd ../

echo "import ssl
ssl._create_default_https_context = ssl._create_unverified_context" | cat - train.py  > a.tmp && mv -f a.tmp train.py

gdown https://drive.google.com/uc?id=11HMSaEkN__QiAZSnCuaM6GI143xo62KO
unzip short_hair.zip
mv short_hair/ poses/


gdown https://drive.google.com/uc?id=1XMrJf9Lk_dWgXyTJhbEK2LZIXL9G3MWc
unzip double_ponytail_images.zip
mv double_ponytail_images/ character_sheet/
ls character_sheet/

mkdir results
python -m torch.distributed.launch \
--nproc_per_node=1 --use-env train.py --mode=test \
--world_size=1 --dataloaders=2 \
--test_input_poses_images=./poses/ \
--test_input_person_images=./character_sheet/ \
--test_output_dir=./results/ \
--test_checkpoint_dir=./weights/ 

#@title 将生成的图片合成为视频
ffmpeg -r 30 -y -i ./results/%d.png -r 30 -c:v libx264 output.mp4 -r 30

wget https://github.com/KurisuMakise004/MMD2UDP/raw/main/MMD2UDP_linux.7z

yum -y install p7zip p7zip-plugins
7z x MMD2UDP_linux.7z 

# Output will be placed at /content/udp/output
cp model.zip ./udp/
cp motion.vmd ./udp/
cp camera.vmd ./udp/
cd ./udp/ && chmod +x ./udp && ./udp




