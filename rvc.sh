#!/bin/sh
cd /usr/local/src
git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI
cd Retrieval-based-Voice-Conversion-WebUI/
python -m venv venv
source venv/bin/activate
source /etc/profile
cd /usr/local/src/Retrieval-based-Voice-Conversion-WebUI/assets/pretrained
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/D32k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/D40k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/D48k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/G48k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/G40k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/G32k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0D32k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0D40k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0D48k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0G48k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0G40k.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0G32k.pth
chmod -R 755 ./*
cp assets/pretrained/* assets/pretrained_v2/
cd /usr/local/src/Retrieval-based-Voice-Conversion-WebUI/assets/uvr5_weights/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP2-人声vocals+非人声instrumentals.pth
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP5-主旋律人声vocals+其他instrumentals.pth
cd /usr/local/src/Retrieval-based-Voice-Conversion-WebUI/assets/hubert/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt
cd /usr/local/src/Retrieval-based-Voice-Conversion-WebUI/assets/rmvpe
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt
cd /usr/local/src/Retrieval-based-Voice-Conversion-WebUI/
pip install -r requirements.txt 
python infer-web.py