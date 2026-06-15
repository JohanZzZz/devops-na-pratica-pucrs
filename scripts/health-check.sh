#!/bin/bash

CONTAINER_NAME="devops-app"
APP_URL="http://localhost"

echo "=== Health Check ==="

echo "--- Status do Container ---"
docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "--- Verificação dos Endpoints ---"

for endpoint in "/" "/api/status" "/api/info"; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${APP_URL}${endpoint}" 2>/dev/null)
  if [ "$STATUS" = "200" ]; then
    echo "[OK]    ${endpoint} -> HTTP ${STATUS}"
  else
    echo "[FALHA] ${endpoint} -> HTTP ${STATUS}"
  fi
done

echo ""
echo "--- Logs Recentes ---"
docker logs --tail 10 "${CONTAINER_NAME}" 2>/dev/null || echo "Container não encontrado."
