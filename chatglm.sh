#!/bin/bash
git clone https://github.com/THUDM/ChatGLM2-6B
cd ChatGLM2-6B
pip install -r requirements.txt
pip install pyqt5==5.15
pip install pyqtwebengine==5.15
cd ChatGLM2-6B/
git clone https://github.com/scg130/thudm  master
#模型下载   https://cloud.tsinghua.edu.cn/d/674208019e314311ab5c/

# web_demo.py
# tokenizer = AutoTokenizer.from_pretrained("THUDM/chatglm2-6b-int4", revision="v1.0",trust_remote_code=True)
# float() 使用cpu   cuda()  使用gpu
# model = AutoModel.from_pretrained("THUDM/chatglm2-6b-int4", trust_remote_code=True).float()
# demo.queue().launch(share=True, inbrowser=True,server_port=6543,server_name="0.0.0.0")

# ModuleNotFoundError: No module named 'transformers_modules.chatglm2-6b'  版本太新问题解决
# pip install transformers==4.26.1


# windows tdm-gcc 安装 https://cloud.tencent.com/developer/article/2251638




# centos install gitlfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
sudo yum install git-lfs
git lfs install


git clone https://github.com/chatchat-space/Langchain-Chatchat.git
cd Langchain-Chatchat
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt 
pip install -r requirements_api.txt
pip install -r requirements_webui.txt  

git lfs install
git clone https://huggingface.co/THUDM/chatglm2-6b
git clone https://huggingface.co/moka-ai/m3e-base

python copy_config_example.py
python init_database.py --recreate-vs


python startup.py -a