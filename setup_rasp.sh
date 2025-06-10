#setup_rasp.sh
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

echo "[INFO] Criando Atalhos"
if [ ! -e ~/Desktop/cameraUSB ]; then
  ln -sf ~/sodavision/sodalens/get_camera.sh ~/Desktop/cameraUSB
fi

echo "[INFO] Instalando Docker"
~/sodavision/sodalens/docker-installer.sh

echo "[INFO] Montando as imagens Docker"
cd ~/sodavision

echo "[INFO] O modo de câmera é: $CAMERA_MODE"
if [ "$CAMERA_MODE" = "usb" ]; then

    echo "[INFO] Tentando detectar câmera USB..."
  if ~/sodavision/sodalens/get_camera.sh; then
    echo "[INFO] Câmera detectada com sucesso."
  else
    echo "[AVISO] Nenhuma câmera funcional detectada. Continuando mesmo assim..."
  fi

  # Se for USB, chama o Docker Compose com o override (por exemplo, docker-compose.webcam.yml)
  sudo docker compose -f docker-compose.yml -f docker-compose.webcam.yml up -d --build
else
  # Se for outro modo (ex: IP), chama apenas o docker-compose.yml
  sudo docker compose up -d --build
fi

sudo shutdown -r now
