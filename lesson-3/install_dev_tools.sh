#!/bin/bash

LOG_FILE="install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "$(date) - Початок встановлення середовища"

# Перевірка та встановлення Docker
if ! command -v docker &>/dev/null; then
    echo "[INFO] Встановлення Docker..."
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "Docker вже встановлений: $(docker --version)"
fi

# Docker Compose
if ! command -v docker-compose &>/dev/null; then
    echo "[INFO] Встановлення Docker Compose..."
    sudo apt install -y docker-compose
else
    echo "Docker Compose вже встановлений: $(docker-compose --version)"
fi

# Python ≥ 3.9
PYTHON_VERSION=$(python3 --version 2>/dev/null | awk '{print $2}')
if [[ -z "$PYTHON_VERSION" || "$(printf '%s\n' "3.9" "$PYTHON_VERSION" | sort -V | head -n1)" != "3.9" ]]; then
    echo "[INFO] Встановлення Python 3.9..."
    sudo apt install -y python3.9 python3.9-venv python3.9-distutils
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
else
    echo "Python вже встановлений: версія $PYTHON_VERSION"
fi

# pip
if ! command -v pip3 &>/dev/null; then
    echo "[INFO] Встановлення pip..."
    sudo apt install -y python3-pip
else
    echo "pip вже встановлений: версія $(pip3 --version)"
fi

# Python-бібліотеки
for pkg in django torch torchvision pillow; do
    if ! pip3 show $pkg &>/dev/null; then
        echo "[INFO] Встановлення $pkg..."
        pip3 install $pkg
    else
        VERSION=$(pip3 show $pkg | grep Version | awk '{print $2}')
        echo "$pkg вже встановлений: версія $VERSION"
    fi
done

echo "$(date) - Встановлення завершено"
