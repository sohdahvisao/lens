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

git checkout test-arquitetura-minipc

echo "[INFO] Adicionando permissões aos scripts.."
cd ~/sodavision/sodalens/
sudo chmod +x ~/sodavision/sodalens/*.sh

echo "[INFO] Python Ambiente Virtual"
python -m venv ~/sodavision/sodalens/.venv
source ~/sodavision/sodalens/.venv/bin/activate
pip install -r requirements.txt

echo "[INFO] Criando diretorios"
[ -d "$HOME/Desktop" ] || mkdir "$HOME/Desktop"

echo "[INFO] Criando Atalhos"
if [ ! -e ~/Desktop/capturador ]; then
  ln -sf ~/sodavision/sodalens/capture.sh ~/Desktop/capturador
fi

if [ ! -e ~/Desktop/zipper ]; then
  ln -sf ~/sodavision/sodalens/zipper.sh ~/Desktop/zipper
fi

if [ ! -d ~/Desktop/datasets ]; then
  ln -sf ~/sodavision/sodalens/datasets ~/Desktop/datasets
fi

if [ ! -d ~/Desktop/modelos ]; then
  ln -sf ~/sodavision/sodalens/modelos ~/Desktop/modelos
fi

if [ ! -d ~/Desktop/update ]; then
  ln -sf ~/sodavision/sodalens/update-vision.sh ~/Desktop/update
fi

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
