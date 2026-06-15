#!/bin/bash
set -e

REGISTRY="ghcr.io"
IMAGE="johannzzz/devops-na-pratica-pucrs"
CONTAINER_NAME="devops-app"
PORT="80:5000"
TAG="${1:?Uso: ./rollback.sh <commit-sha>}"

echo "=== Rollback para versão: ${TAG} ==="

echo "[1/4] Fazendo pull da imagem com tag ${TAG}..."
docker pull "${REGISTRY}/${IMAGE}:${TAG}"

echo "[2/4] Parando container atual..."
docker stop "${CONTAINER_NAME}" 2>/dev/null || true
docker rm "${CONTAINER_NAME}" 2>/dev/null || true

echo "[3/4] Iniciando container com versão ${TAG}..."
docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p "${PORT}" \
  -e FLASK_ENV=production \
  "${REGISTRY}/${IMAGE}:${TAG}"

echo "[4/4] Verificando..."
docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo "=== Rollback concluído ==="
