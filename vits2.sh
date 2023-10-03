#!/bin/bash
git clone https://github.com/fishaudio/Bert-VITS2
pip install -r requirements.txt

#bert 模型 haggingface.co 上下载
bert/bert-base-japanese-v3
bert/chinese-roberta-wwm-ext-large
测试
python text/chinese_bert.py
python text/japanese_bert.py


数据集 raw/
python dataset.py -m woman -l ZH

python preprocess_text.py --transcription-path filelists/woman.list

python resample.py

python bert_gen.py -m woman

python train_ms.py -m woman -c configs/config.json

python webui.py