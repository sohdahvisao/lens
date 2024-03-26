#!/bin/bash
set -ex

echo "[INFO] Downloading script files.."
git clone https://AMBEV-SA@dev.azure.com/AMBEV-SA/AMBEVTECH-SUPPLY-BREWTECH-SODAVISION/_git/mvp-sodalens ~/sodalens

echo "[INFO] Setting script files permissions.."
cd ~/sodalens
sudo chmod +x ~/sodalens/*.sh

echo "[INFO] Python Virtual Environment"
python -m venv ~/sodalens/.venv
source ~/sodalens/.venv/bin/activate
pip install -r requirements.txt

echo "[INFO] Creating shortcuts"
ln -s ~/sodalens/capture.sh ~/Desktop/capturador
ln -s ~/sodalens/datasets ~/Desktop/datasets
