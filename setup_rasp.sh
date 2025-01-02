#!/bin/bash
set -ex

# Lê o primeiro parâmetro (por exemplo, "usb" ou "ip")
CAMERA_MODE="$1"

# Define valor padrão ("usb") caso não seja informado
CAMERA_MODE="${CAMERA_MODE:-usb}"

echo "[INFO] Instalando arquivos de script.."
git clone https://AMBEV-SA@dev.azure.com/AMBEV-SA/ambevtech-brewtech-soda-vision/_git/edge-device ~/sodavision
cd ~/sodavision/

echo "[INFO] Adicionando permissões aos scripts.."
cd ~/sodavision/sodalens/
sudo chmod +x ~/sodavision/sodalens/*.sh

echo "[INFO] Python Ambiente Virtual"
python -m venv ~/sodavision/sodalens/.venv
source ~/sodavision/sodalens/.venv/bin/activate
pip install -r requirements.txt

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
if [ "$CAMERA_MODE" = "usb" ]; then
  # Se for USB, chama o Docker Compose com o override (por exemplo, docker-compose.webcam.yml)
  sudo docker compose -f docker-compose.yml -f docker-compose.webcam.yml up -d --build
else
  # Se for outro modo (ex: IP), chama apenas o docker-compose.yml
  sudo docker compose up -d --build
fi

sudo shutdown -r now
