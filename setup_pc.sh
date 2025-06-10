#!/bin/bash
set -ex

# Lê o primeiro parâmetro (por exemplo, "usb" ou "ip")
CAMERA_MODE="$1"

# Define valor padrão ("usb") caso não seja informado
CAMERA_MODE="${CAMERA_MODE:-usb}"

echo "[INFO] Instalando dependencias.."
sudo apt update
sudo apt install curl
sudo apt install git
sudo apt install python-is-python3
alias python=python3
sudo apt install python3-venv

echo "[INFO] Instalando arquivos de script.."
git clone https://AMBEV-SA@dev.azure.com/AMBEV-SA/ambevtech-brewtech-soda-vision/_git/edge-device ~/sodavision
cd ~/sodavision/

git checkout feat-arquitetura-minipc

echo "[INFO] Adicionando permissões aos scripts.."
cd ~/sodavision/sodalens/
sudo chmod +x ~/sodavision/sodalens/*.sh

echo "[INFO] Instalando Docker"
~/sodavision/sodalens/docker-installer.sh

echo "[INFO] Montando as imagens Docker"
cd ~/sodavision

echo "[INFO] O modo de câmera é: $CAMERA_MODE"
if [ "$CAMERA_MODE" == "usb" ]; then
  sudo make build CAMERA=usb
else
  sudo make build CAMERA=$CAMERA_MODE
fi

sudo shutdown -r 0
