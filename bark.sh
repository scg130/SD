#!/bin/bash
git clone https://github.com/KevinWang676/Bark-Voice-Cloning
cd Bark-Voice-Cloning
cd sambert-ui
pip install -r requirements.txt
sudo apt install build-essential
pip install kantts -f https://modelscope.oss-cn-beijing.aliyuncs.com/releases/repo.html
pip install tts-autolabel -f https://modelscope.oss-cn-beijing.aliyuncs.com/releases/repo.html
pip install sox # 也可以选择 apt-get install sox 来安装sox依赖

pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchtext==0.14.1 torchaudio==0.13.1 torchdata==0.5.1 --extra-index-url https://download.pytorch.org/whl/cu117

python app.py




# from modelscope.pipelines import pipeline
# from modelscope.utils.constant import Tasks

# 音乐转换
# infer = pipeline(task=Tasks.auto_speech_recognition, name='Bark-Voice-Cloning')
# result = infer('./data/test.wav')
# print(result)

# 文字转音频
# infer = pipeline(task=Tasks.text_to_speech, name='Bark-Voice-Cloning')
# result = infer('你好')
# print(result)