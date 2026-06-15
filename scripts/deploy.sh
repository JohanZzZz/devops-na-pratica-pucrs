#!/bin/bash
set -e

REGISTRY="ghcr.io"
IMAGE="johannzzz/devops-na-pratica-pucrs"
CONTAINER_NAME="devops-app"
PORT="80:5000"

echo "=== Deploy iniciado ==="

echo "[1/5] Fazendo pull da imagem mais recente..."
docker pull "${REGISTRY}/${IMAGE}:latest"

echo "[2/5] Parando container atual..."
docker stop "${CONTAINER_NAME}" 2>/dev/null || echo "Nenhum container rodando."

echo "[3/5] Removendo container antigo..."
docker rm "${CONTAINER_NAME}" 2>/dev/null || echo "Nenhum container para remover."

echo "[4/5] Iniciando novo container..."
docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p "${PORT}" \
  -e FLASK_ENV=production \
  "${REGISTRY}/${IMAGE}:latest"

echo "[5/5] Limpando imagens antigas..."
docker image prune -f

echo "=== Deploy concluído ==="
echo "Aplicação disponível em: http://$(hostname -I | awk '{print $1}')"
docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
