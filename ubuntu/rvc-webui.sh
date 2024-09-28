#!/bin/bash
git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git
cd Retrieval-based-Voice-Conversion-WebUI/
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python -m pip install --upgrade pip
python tools/download_models.py
python infer-web.py
