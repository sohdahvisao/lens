#!/bin/bash
set -ex

echo "[INFO] Downloading script files.."
git clone https://AMBEV-SA@dev.azure.com/AMBEV-SA/AMBEVTECH-SUPPLY-BREWTECH-SODAVISION/_git/mvp-edge-device ~/sodavision
cd ~/sodavision/
git checkout back-front

echo "[INFO] Setting script files permissions.."
cd ~/sodavision/sodalens/
sudo chmod +x ~/sodavision/sodalens/*.sh

echo "[INFO] Python Virtual Environment"
python -m venv ~/sodavision/sodalens/.venv
source ~/sodavision/sodalens/.venv/bin/activate
pip install -r requirements.txt

echo "[INFO] Creating shortcuts"
ln -s ~/sodavision/sodalens/capture.sh ~/Desktop/capturador
ln -s ~/sodavision/sodalens/datasets ~/Desktop/datasets

echo "[INFO] Instalando Docker"
~/sodavision/sodalens/docker-installer.sh

echo "[INFO] Montando as imagens Docker"
cd ~/sodavision
sudo docker compose up -d --build

sudo shutdown -r now
