#!/bin/bash
git clone https://github.com/scg130/bark-voice-clone.git
cd bark-voice-clone
cd sambert-ui
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
yum groupinstall "Development Tools" #sudo apt install build-essential
pip install kantts -f https://modelscope.oss-cn-beijing.aliyuncs.com/releases/repo.html
pip install tts-autolabel -f https://modelscope.oss-cn-beijing.aliyuncs.com/releases/repo.html
pip install sox # 也可以选择 apt-get install sox 来安装sox依赖

pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchtext==0.14.1 torchaudio==0.13.1 torchdata==0.5.1 --extra-index-url https://download.pytorch.org/whl/cu117

echo "import ssl
ssl._create_default_https_context = ssl._create_unverified_context" | cat - app.py  > a.tmp && mv -f a.tmp app.py
sed -i 's/server_port=consts.port,/server_port=consts.port,share=True,/g' app.py

python app.py




# from modelscope.pipelines import pipeline
# from modelscope.utils.constant import Tasks

# 语音识别
# infer = pipeline(task=Tasks.auto_speech_recognition, name='Bark-Voice-Cloning')
# result = infer('./data/test.wav')
# print(result)

# 文字转音频
# infer = pipeline(task=Tasks.text_to_speech, name='Bark-Voice-Cloning')
# result = infer('你好')
# print(result)


# ffmpeg -f concat -i list.txt out.wav

# list.txt

# file 1.wav
# file 2.wav
# file 3.wav